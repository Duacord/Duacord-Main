local EventHandler = Class:extend()

EventHandler.Events = {}

function EventHandler:initialize(Client)
    self.Client = Client
end

function EventHandler.Events.READY(Client, Shard, Data)
    print(Json.encode(Data, {indent = true}))
    Shard.SessionId = Data.session_id
    Client:Info("Recieved ready!")
    Client:emit("Ready")
end

function EventHandler.Events.GUILD_CREATE(Client, Shard, Data)
    Client.Guilds[Data.id] = Client.Classes.Objects.Guild:new(Data, Client)
end

function EventHandler:Handle(Data, Shard)

    p(Data.t)
    --print(Json.encode(Data.d, {indent = true}))
    --p()
    self.Client:emit("Raw", Data) 

    if self.Events[Data.t] then
        Shard.Sequence = Data.s
        self.Events[Data.t](self.Client, Shard, Data.d)
    else
        self.Client:Warn("Unhandled gateway event: " .. Data.t)
    end
end

return EventHandler