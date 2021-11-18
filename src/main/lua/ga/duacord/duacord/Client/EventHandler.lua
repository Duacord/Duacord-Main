local EventHandler = Class:extend()

function EventHandler:initialize(Gateway)

    self.Gateway = Gateway
    self.Client = self.Gateway.Client

end

EventHandler.Events = {}

function EventHandler.Events.READY(Client, Data)
    Client.Logger:Info("Received Ready")
    Client.GuildCount = #Data.guilds
    Client.User = Client.Classes.Classes.User:new(Data.user)
    Client.SessionId = Data.session_id
end

function EventHandler.Events.GUILD_CREATE(Client, Data)
    Client.Logger:Info("Received Guilds")
    Client.Guilds[Data.id] = Client.Classes.Classes.Guild:new(Data, Client)

    local GuildCount = 0

    for Index, IndexedGuild in pairs(Client.Guilds) do
        GuildCount = GuildCount + 1
    end
    
    if GuildCount == Client.GuildCount then
        Client:emit("Ready")
    end
end

function EventHandler.Events.GUILD_UPDATE(Client, Data)

end

function EventHandler.Events.TYPING_START(Client, Data)
    print(table.ToString(Data))
end

function EventHandler:HandleEvent(Message)
    if Message.op == 0 then
        if self.Events[Message.t] then
            self.Events[Message.t](self.Client, Message.d)
        else
            self.Client.Logger:Warn(string.format("Unhandled gateway event '%s'", Message.t))
        end
    elseif Message.op == 10 then
        self.Client.Logger:Info("Received Hello")
        self.Client:emit("Hello")
    elseif Message.op == 11 then
        self.Client:emit("HeartBeatAck")
    end
end

return EventHandler