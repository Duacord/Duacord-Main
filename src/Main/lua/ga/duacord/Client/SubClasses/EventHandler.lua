local EventHandler = Import("ga.corebyte.BetterEmitter"):extend()

local Constant = Import("ga.duacord.Client.API.Constant")
local GatewayOpcodes = Constant.Gateway.Opcodes

local GuildClass = Import("ga.duacord.Client.Objects.Guild")
local MessageClass = Import("ga.duacord.Client.Objects.Message")
local UserClass = Import("ga.duacord.Client.Objects.User")

local InteractionClass = Import("ga.duacord.Client.Objects.Interaction")

local function CountTable(ToCount)
    local Amount = 0
    for _, _ in pairs(ToCount) do
        Amount = Amount + 1
    end
    return Amount
end

function EventHandler:initialize(Client, Shard)
    self.Client = Client
    self.Shard = Shard
end

function EventHandler:HandleMessage(Message)
    local Opcode = Message.op
    local Data = Message.d
    local Sequence = Message.s
    local Event = Message.t

    if Sequence ~= nil then
        self.Shard.LastSequence = Sequence
    end

    if Opcode == GatewayOpcodes.Dispatch then
        self.Client:Emit("Raw", Message)
        self:HandleDispatch(Data, Event)
    elseif Opcode == GatewayOpcodes.Heartbeat then
        self.Shard:SendHeartBeat()
    elseif Opcode == GatewayOpcodes.Reconnect then
        TypeWriter.Logger.Info("Discord has requested a reconnection")
        self.Client:Emit("Reconnect")
        self.Shard:Reconnect()
    elseif Opcode == GatewayOpcodes.InvalidSession then
        TypeWriter.Logger.Info("Discord has invalidated the session")
        self.Shard.SessionId = nil
        self.Shard:Reconnect()
    elseif Opcode == GatewayOpcodes.Hello then
        TypeWriter.Logger.Info("Shard " .. self.Shard.Id .. ": Received HELLO")
        self.Shard.HeartbeatInterval = Data.heartbeat_interval
        self.Shard:Authenticate(self.Shard.SessionId == nil)
        self.Shard:StartHeart()
        self.Client:Emit("Hello")
    elseif Opcode == GatewayOpcodes.HeartbeatAck then
        self:Emit("HeartbeatAck")
    end

end

function EventHandler:HandleDispatch(Data, Event)
    print(Event)
    --for Index, Value in pairs(Data) do
    --    print(Index, Value)
    --end
    --print(require("json").encode(Data, {indent = true}))
    print()

    if self.DispatchEvents[Event] then
        self.DispatchEvents[Event](Data, self.Client, self.Shard)
    else
        TypeWriter.Logger.Warn("Received unknown event: " .. Event)
    end
end

EventHandler.DispatchEvents = {}

function EventHandler.DispatchEvents.READY(Data, Client, Shard)
    TypeWriter.Logger.Info("Shard " .. Shard.Id .. ": Received READY")
    TypeWriter.Logger.Info("Shard " .. Shard.Id .. ": Logged in as " .. Data.user.username .. "#" .. Data.user.discriminator)
    Shard.SessionId = Data.session_id

    local User = UserClass:new(Client)
    Client.API:InsertTable(User, Client.API:PatchTable(Data.user))
    Client.User = User

    for Index, Guild in pairs(Data.guilds) do
        Shard.ExpectedGuilds[Guild.id] = true
    end

    Client:Emit("Ready")
end

function EventHandler.DispatchEvents.RESUMED(Data, Client, Shard)
    TypeWriter.Logger.Info("Shard " .. Shard.Id .. ": Received RESUMED")
    Client:Emit("Resumed", Shard.Id)
end

function EventHandler.DispatchEvents.INTERACTION_CREATE(Data, Client, Shard)
    local Interaction = InteractionClass:new(Client)
    Client.API:InsertTable(Interaction, Client.API:PatchTable(Data))
    Client:Emit("RawInteraction", Interaction, Interaction.Type)
end

--Application Command Permissions Update	application command permission was updated
function EventHandler.DispatchEvents.APPLICATION_COMMAND_PERMISSIONS_UPDATE(Data, Client, Shard)
    
end
--Channel Create	new guild channel created
--Channel Update	channel was updated
--Channel Delete	channel was deleted
--Channel Pins Update	message was pinned or unpinned
--Thread Create	thread created, also sent when being added to a private thread
--Thread Update	thread was updated
--Thread Delete	thread was deleted
--Thread List Sync	sent when gaining access to a channel, contains all active threads in that channel
--Thread Member Update	thread member for the current user was updated
--Thread Members Update	some user(s) were added to or removed from a thread

--Guild Create	lazy-load for unavailable guild, guild became available, or user joined a new guild
function EventHandler.DispatchEvents.GUILD_CREATE(Data, Client, Shard)
    local Guild = GuildClass:new(Client)
    Client.API:InsertTable(Guild, Shard.Client.API:PatchTable(Data))
    Shard.Assinged.Guilds[Guild.Id] = true
    Client.Guilds[Guild.Id] = Guild
    Shard.ExpectedGuilds[Guild.Id] = nil
    if CountTable(Shard.ExpectedGuilds) == 0 then
        Shard:Emit("GuildsLoaded")
    else
        Client:Emit("GuildCreate", Guild)
    end
end

--Guild Update	guild was updated
function EventHandler.DispatchEvents.GUILD_UPDATE(Data, Client, Shard)
    local Guild = Client:GetGuild(Data.id)
    if Guild == nil then return end
    Client.API:InsertTable(
        Guild,
        Client.API:PatchTable(Data)
    )
    Client:Emit("GuildUpdate")
end

--Guild Delete	guild became unavailable, or user left/was removed from a guild
function EventHandler.DispatchEvents.GUILD_DELETE(Data, Client, Shard)
    local Guild = Client:GetGuild(Data.id)
    if Guild == nil then return end
    --Client.API:RemoveTable(Guild) ill make this soon
    Client.Guilds[Guild.Id] = nil
    Client:Emit("GuildDelete", Guild)
end
--Guild Ban Add	user was banned from a guild
--Guild Ban Remove	user was unbanned from a guild
--Guild Emojis Update	guild emojis were updated
--Guild Stickers Update	guild stickers were updated
--Guild Integrations Update	guild integration was updated
--Guild Member Add	new user joined a guild
--Guild Member Remove	user was removed from a guild
--Guild Member Update	guild member was updated
--Guild Members Chunk	response to Request Guild Members
--Guild Role Create	guild role was created
--Guild Role Update	guild role was updated
--Guild Role Delete	guild role was deleted
--Guild Scheduled Event Create	guild scheduled event was created
--Guild Scheduled Event Update	guild scheduled event was updated
--Guild Scheduled Event Delete	guild scheduled event was deleted
--Guild Scheduled Event User Add	user subscribed to a guild scheduled event
--Guild Scheduled Event User Remove	user unsubscribed from a guild scheduled event
--Integration Create	guild integration was created
--Integration Update	guild integration was updated
--Integration Delete	guild integration was deleted
--Interaction Create	user used an interaction, such as an Application Command
--Invite Create	invite to a channel was created
--Invite Delete	invite to a channel was deleted
--Message Create	message was created
function EventHandler.DispatchEvents.MESSAGE_CREATE(Data, Client, Shard)
    local Message = MessageClass:new(Client)
    Client.API:InsertTable(
        Message,
        Client.API:PatchTable(Data)
    )
    Client:Emit("MessageCreate", Message)
end
--Message Update	message was edited
--Message Delete	message was deleted
--Message Delete Bulk	multiple messages were deleted at once
--Message Reaction Add	user reacted to a message
--Message Reaction Remove	user removed a reaction from a message
--Message Reaction Remove All	all reactions were explicitly removed from a message
--Message Reaction Remove Emoji	all reactions for a given emoji were explicitly removed from a message
--Presence Update	user was updated
function EventHandler.DispatchEvents.PRESENCE_UPDATE(Data, Client, Shard)
    --p(Data)
    --print()
    --for Index, Value in pairs(Client:GetGuild(Data.guild_id):GetMember(Data.user.id)) do
    --    print(Index, Value)
    --end
end
--Stage Instance Create	stage instance was created
--Stage Instance Delete	stage instance was deleted or closed
--Stage Instance Update	stage instance was updated
--Typing Start	user started typing in a channel
--User Update	properties about the user changed
--Voice State Update	someone joined, left, or moved a voice channel
--Voice Server Update	guild's voice server was updated
--Webhooks Update	guild channel webhook was created, update, or deleted

return EventHandler