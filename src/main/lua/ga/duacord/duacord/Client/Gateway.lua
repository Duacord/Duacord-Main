local Gateway = Class:extend()
local HttpHelper = Import("ga.duacord.http.Main")
local WebSocket = HttpHelper["coro-websocket"]
local WebRequest = HttpHelper["coro-http"].request
local EventHandler = Import("ga.duacord.duacord.Client.EventHandler")

local HttpConstant = Import("ga.duacord.duacord.Constants.HTTP")

function Gateway:initialize(GatewayClient)
    self.Client = GatewayClient
    self.EventHandler = EventHandler:new(self)
end

function GetConnection(Url, Path)
    local Options = WebSocket.parseUrl(Url)
    Options.pathname = Path
    
    return WebSocket.connect(Options)
end

function Gateway:Connect()
    local Response, Body = WebRequest(
        "GET",
        HttpConstant.BaseUrl .. HttpConstant.GatewayRequest,
        {
            {"Authorization", self.Client.Token}
        }
    )

    self.SocketData = Json.decode(Body)

    local Response, Read, Write = GetConnection(self.SocketData.url, "/?v=9&encoding=json")

    self.SocketConnection = {Response = Response, Read = Read, Write = Write}

    self.SendHeartBeat = function()
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
    end

    self.Heart = coroutine.wrap(function()
        self.SendHeartBeat()

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
            Sleep(self.HeartSpeed)
            self.SendHeartBeat()
        end
    end)


    while true do
        local Message = Read()
        
        if Message and string.sub(Message.payload, 1, 1) == "{" then

            local Decoded = Json.decode(Message.payload)

            --p(Decoded)
            self.EventHandler:HandleEvent(Decoded)

            if Decoded.op == 10 and not self.HeartSpeed then
                self.HeartSpeed = Decoded.d["heartbeat_interval"]
                self.Heart()
            elseif Decoded.op == 10 then
                self.Heart()
            end

        else

        end

    end

end

return Gateway