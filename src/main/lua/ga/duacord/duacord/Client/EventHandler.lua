local EventHandler = Class:extend()
local ReMap = Import("ga.duacord.duacord.API.ReMap")

function EventHandler:initialize(Gateway)

    self.Gateway = Gateway
    self.Client = self.Gateway.Client

end

EventHandler.Events = {}

function EventHandler.Events.READY(Client, Data)
    p(Data)
    Client.Logger:Info("Received Ready")
    Client.GuildCount = #Data.guilds
    Client.User = Client.Classes.Classes.User:new(Data.user)
    Client.SessionId = Data.session_id

    Client:emit("Ready")
end

function EventHandler.Events.GUILD_CREATE(Client, Data)
    Client.Logger:Info("Received Guilds")
    Client.Guilds[Data.id] = Client.Classes.Classes.Guild:new(Data, Client)

    local GuildCount = 0

    for Index, IndexedGuild in pairs(Client.Guilds) do
        GuildCount = GuildCount + 1
    end
    
    if GuildCount == Client.GuildCount then
        Client:emit("Loaded")
    end
end

function EventHandler.Events.GUILD_UPDATE(Client, Data)
    p(Data)

    ReMap(Client:GetGuild(Data.id), Data)
    Client:emit("GuildUpdate")
end

function EventHandler.Events.GUILD_ROLE_UPDATE(Client, Data)
   print(table.ToString(Data)) 
   Client:GetGuild(Data.guild_id):GetRole(Data.role.id):Update(Data.role)
   Client:emit("RoleUpdate", Client:GetGuild(Data.guild_id):GetRole(Data.role.id))
end

function EventHandler:HandleEvent(Message)
    self.Gateway.Sequence = Message.s or self.Gateway.Sequence

    if Message.op == 0 then
        if self.Events[Message.t] then
            self.Events[Message.t](self.Client, Message.d)
        else
            self.Client.Logger:Warn(string.format("Unhandled gateway event '%s'", Message.t))
            print(Json.encode(Message.d, {indent = true}))
        end
    elseif Message.op == 10 then
        self.Client.Logger:Info("Received Hello")
        self.Client:emit("Hello")
    elseif Message.op == 11 then
        self.Client:emit("HeartBeatAck")
    end
end

return EventHandler