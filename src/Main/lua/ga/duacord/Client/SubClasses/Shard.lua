local Shard = Import("ga.corebyte.BetterEmitter"):extend()

local Constant = Import("ga.duacord.Client.API.Constant")

local EventHandler = Import("ga.duacord.Client.SubClasses.EventHandler")

local Websocket = require("coro-websocket")
local Json = require("json")
local Timer = require("timer")

function Shard:initialize(Client, Id)
    self.Client = Client
    self.Id = Id
    self.HeartRunning = false

    self.EventHandler = EventHandler:new(self.Client, self)

    self.ExpectedGuilds = {}

    self.Assinged = {}
    self.Assinged.Guilds = {}
end

local function ConnectWebsocket(Url, Path)
    local Options = Websocket.parseUrl(Url)
    Options.pathname = Path
    return Websocket.connect(Options)
end

function Shard:Connect()
    TypeWriter.Logger.Info("Shard " .. self.Id .. ": Connecting to " .. self.Client.GatewayInfo.Url)

    local Response, Read, Write = ConnectWebsocket(
        self.Client.GatewayInfo.Url,
        string.format("/?v=%s&encoding=json", Constant.Discord.Version)
    )

    if not Response then
        TypeWriter.Logger.Error("Shard " .. self.Id .. ": Failed to connect to " .. self.Client.GatewayInfo.Url .. " " .. Read)
        process:exit(1)
    end

    self.Read = Read
    self.Write = Write

    for Message in Read do
        if #Message.payload == 0 or Message.opcode == Constant.Websocket.CLOSE then
            if Message.payload ~= nil then
                TypeWriter.Logger.Error("Shard " .. self.Id .. ": Websocket closed with message: " .. Message.payload)
            else
                TypeWriter.Logger.Error("Shard " .. self.Id .. ": Websocket closed")
            end
            break
        end

        local Decoded = Json.decode(Message.payload)
        if Decoded ~= nil then
            self.EventHandler:HandleMessage(Decoded)
        else
            p(Message)
        end

    end

    TypeWriter.Logger.Info("Shard " .. self.Id .. ": Disconnected")

    self:StopHeart()
    self.Read = nil
    self.Write = nil

end

function Shard:Disconnect()
    if self.Read == nil then return end
    self:StopHeart()
    self.Write()
    self.Read = nil
    self.Write = nil
end

function Shard:Reconnect()
    self:Disconnect()
    self:Connect()
end

function Shard:StartHeart()
    if self.HeartRunning then return end
    self.HeartRunning = true
    self:SendHeartBeat()
    self.Heart = Timer.setInterval(
        self.HeartbeatInterval,
        function()
            if self.Read == nil then return end
            coroutine.wrap(
                function()
                    self:SendHeartBeat()
                    self.EventHandler:WaitFor("HeartbeatAck", 5)
                end
            )()
        end
    )
end

function Shard:StopHeart()
    if not self.HeartRunning then return end
    self.HeartRunning = false
    Timer.clearInterval(self.Heart)
end

function Shard:SendHeartBeat()
    self:Send(Constant.Gateway.Opcodes.Heartbeat, self.LastSequence or Json.null)
end

function Shard:Send(Op, D)
    if self.Write == nil then
        TypeWriter.Logger.Error("Shard " .. self.Id .. ": Trying to send but Not connected")
        return nil
    end

    self.Write(
        {
            opcode = Constant.Websocket.Opcodes.TEXT,
            payload = Json.encode(
                {
                    op = Op,
                    d = D
                }
            )
        }
    )
    return true
end

function Shard:Authenticate(Identify)
    local Os = require("los").type()
    local PackageName = TypeWriter.LoadedPackages.duacord.Package.Name

    if Identify == true then -- identify
        self:Send(
            Constant.Gateway.Opcodes.Identify,
            {
                token = self.Client.Token,
                properties = {
                    ["$os"] = Os,
                    ["$browser"] = PackageName,
                    ["$device"] = PackageName
                },
                compress = false,
                large_threshold = 250,
                shard = {
                    self.Id,
                    self.Client.GatewayInfo.Shards
                },
                intents = 130047,
            }
        )
    elseif Identify == false then -- reconnect
        self:Send(
            Constant.Gateway.Opcodes.Resume,
            {
                token = self.Client.Token,
                session_id = self.SessionId,
                seq = self.LastSequence,
            }
        )
    end
end

return Shard