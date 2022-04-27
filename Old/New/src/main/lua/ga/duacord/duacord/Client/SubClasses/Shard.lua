local Shard = Class:extend()

local Socket = Import("ga.duacord.http.Main")["coro-websocket"]
local SetInterval = Timer.setInterval

function Shard:initialize(Client, Id)
    self.Client = Client
    self.Heart = {}
    self.Id = Id
end

local function GetConnection(Url, Path)
    local Options = Socket.parseUrl(Url)
    Options.pathname = Path
    
    return Socket.connect(Options)
end

function Shard:Identify()
    self:Send(
        self.Client.Constants.Opcodes.DISCORD.IDENTIFY,
        {
            token = self.Client.Token,
            properties = {
                ["$os"] = LOS.type(),
                ["$browser"] = "DuaCord",
                ["$device"] = "DuaCord"
            },
            shard = {self.Id, #self.Client.Shards},
            intents = 32767
        },
        true
    )
end

local function Beat(Shard)
    Shard:HeartBeat()
end

function Shard:HeartBeat()
    coroutine.wrap(function ()
        self:Send(self.Client.Constants.Opcodes.DISCORD.HEARTBEAT, self.Sequence or Json.null)
        self.Client:Debug("HeartBeat Send")
    end)()
end

function Shard:HandleText(Message)
    local DiscordOpcodes = self.Client.Constants.Opcodes.DISCORD

    if Message.op == DiscordOpcodes.DISPATCH then
        self.Client.EventHandler:Handle(Message, self)
    elseif Message.op == DiscordOpcodes.HELLO then
        self.Client:Info("Recieved hello!")
        self.Heart.Speed = Message.d.heartbeat_interval
        self.Client:Debug("Heart Speed set to " .. self.Heart.Speed)
        self.Heart.Beat = SetInterval(self.Heart.Speed, Beat, self)
        self:HeartBeat()
        self:Identify()
        self.Client:emit("Hello")
    end
    
end

function Shard:HandleMessage(Message)
    local Opcodes = self.Client.Constants.Opcodes

    local Opcode = Message.opcode
    local Payload = Message.payload

    if Opcode == Opcodes.WEBSOCKET.TEXT then
        self:HandleText(Json.decode(Message.payload))
        return true
    end
end

function Shard:Connect(ConnectionData)
    local Response, Read, Write = GetConnection(
        ConnectionData.url,
        string.format(
            "/?v=%s&encoding=json",
            self.Client.Constants.API.API_VERSION
        )
    )

    self.Read = Read
    self.Write = Write

    for Message in self.Read do
        local Keep = self:HandleMessage(Message)
        if not Keep then self.Client:Debug(Message.payload) break end
    end

    self.Client:Info("Disconnected")

end

function Shard:Send(Opcode, Data, Identify)
    if self.Write then
        self.Write(
            {
                opcode = self.Client.Constants.Opcodes.WEBSOCKET.TEXT,
                payload = Json.encode(
                    {
                        d = Data,
                        op = Opcode
                    }
                )
            }
        )
    end
end

return Shard