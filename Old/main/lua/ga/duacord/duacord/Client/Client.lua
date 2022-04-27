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

function Client:initialize()
    

    self.Classes = {
        Client = {
            EventHandler = Import("ga.duacord.duacord.Client.EventHandler"),
            Gateway = Import("ga.duacord.duacord.Client.Gateway")
        },

        Constants = {
            EndPoints = Import("ga.duacord.duacord.Constants.Endpoints"),
            HTTP = Import("ga.duacord.duacord.Constants.HTTP"),
        },

        Classes = {
            Channel = Import("ga.duacord.duacord.Classes.Channel"),
            Guild = Import("ga.duacord.duacord.Classes.Guild"),
            Member = Import("ga.duacord.duacord.Classes.Member"),
            Role = Import("ga.duacord.duacord.Classes.Role"),
            User = Import("ga.duacord.duacord.Classes.User"),
        }
    }
end

function Client.meta:__tostring()
    return "Client: " .. ((self.User or {}).Id or "Client is loading") .. string.format(" (%s)", (self.User or {}).Name or "Client is loading")
end

function Client:Run(Token, Settings)
    local ConnectionToken = ("Bot ") .. Token
    
    self.Token = ConnectionToken
    self.API = API:new(self)
    self.AuthHeader = {"Authorization", self.Token}
    self.Gateway = Gateway:new(self)
    self.Settings = ParseSettings(Settings or {})
    self.Logger = Logger:new({Debug = self.Settings.Debug})
    self.Logger:Info("Duacord discord library")
    self.Guilds = {}

    coroutine.wrap(function()
        self.Gateway:Connect()
    end)()

end

function Client:GetGuild(Id)
    return self.Guilds[Id]
end

return Client