local Client = Class:extend()
local Gateway = Import("ga.duacord.duacord.Client.Gateway")
local Logger = Import("nl.cubic-inc.logger.Main")
local API = Import("ga.duacord.duacord.API.API")


local DefaultSettings = {
    Intents = 32767,
    Debug = false
}

function ParseSettings(Settings)
    local ParsedSettings = {}
    for Index, Setting in pairs(DefaultSettings) do
        ParsedSettings[Index] = Settings[Index] or Setting
    end
    return ParsedSettings
end

function Client:Run(Token, TokenType, Settings)
    local ConnectionToken = (TokenType or "Bot ") .. Token
    
    self.Token = ConnectionToken
    self.API = API:new(self)
    self.AuthHeader = {"Authorization", self.Token}
    self.Gateway = Gateway:new(self)
    self.Settings = ParseSettings(Settings or {})
    self.Logger = Logger:new({Debug = self.Settings.Debug})
    self.Guilds = {}

    coroutine.wrap(function()
        self.Gateway:Connect()
    end)()

    --print(Import("ga.duacord.duacord.Libraries.TableToString")(self))



end

function Client:GetGuild(Id)
    return self.Guilds[Id]
end

return Client