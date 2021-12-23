local Gateway = Class:extend()
local HttpHelper = Import("ga.duacord.http.Main")
local WebSocket = HttpHelper["coro-websocket"]
local WebRequest = HttpHelper["coro-http"].request
local EventHandler = Import("ga.duacord.duacord.Client.EventHandler")

local HttpConstant = Import("ga.duacord.duacord.Constants.HTTP")

function Gateway:initialize(GatewayClient)
    self.Client = GatewayClient
    self.EventHandler = EventHandler:new(self)
    self.HeartInfo = {Returned = true}
end

function GetConnection(Url, Path)
    local Options = WebSocket.parseUrl(Url)
    Options.pathname = Path
    
    return WebSocket.connect(Options)
end

function Gateway:Connect()

    self.Client.Logger:Info("Connecting to discord!")

    local Response, Body = WebRequest(
        "GET",
        HttpConstant.BASEURL .. HttpConstant.GATEWAY_BOT,
        {
            {"Authorization", self.Client.Token}
        }
    )

    self.SocketData = Json.decode(Body)

    local Response, Read, Write = GetConnection(self.SocketData.url, "/?v=9&encoding=json")

    self.SocketConnection = {--[[Response = Response, ]]Read = Read, Write = Write}

    self.HeartInfo.SendHeartBeat = function()
        if self.HeartInfo.Returned == false then
            self.Client.Logger:Warn("Connection might be ghosted (" .. self.Sequence .. ")")
            
        end
        self.SocketConnection.Write(
            {
               payload = Json.encode(
                    {
                        op = 1,
                        d = Json.null
                    }
                ) 
            }
            
        )


        self.HeartInfo.Returned = false
    end

    self.HeartInfo.Heart = coroutine.wrap(function()
        self.Client.Logger:Info(string.format("Starting Heart (Speed set to %s seconds)", self.HeartInfo.HeartSpeed / 1000))
        self.HeartInfo.SendHeartBeat()

        self.SocketConnection.Write({payload = Json.encode({
            op = 2, d = {
                token = self.Client.Token,
                properties = {
                    ["$os"] = LOS.type(),
                    ["$browser"] = "DuaCord",
                    ["$device"] = "DuaCord"
                },
                large_threshold = 250,
                presence = {
                    activities = {
                        {
                            name = "Cards Against Humanity",
                            type = 0
                        }
                    },
                    status = "dnd",
                    since = 91879201,
                    afk = false
                },
                intents = self.Client.Settings.Intents
        }})})

        while true do
            Sleep(self.HeartInfo.HeartSpeed)
            self.HeartInfo.SendHeartBeat()
        end
    end)


    while true do
        local Message = Read()
        
        if Message and string.sub(Message.payload, 1, 1) == "{" then

            local Decoded = Json.decode(Message.payload)

            self.EventHandler:HandleEvent(Decoded)

            if Decoded.op == 10 and not self.HeartSpeed then
                self.HeartInfo.HeartSpeed = Decoded.d["heartbeat_interval"]
                self.HeartInfo.Heart()
            elseif Decoded.op == 10 then
                self.HeartInfo.Heart()
            end

        else

        end

    end

end

return Gateway