local Client = Import("ga.corebyte.BetterEmitter"):extend()

local API = Import("ga.duacord.Client.API")
local Shard = Import("ga.duacord.Client.SubClasses.Shard")

local DefaultSettings = {
    TokenPrefix = "Bot ",
}

local function ParseSettings(Settings) 
    if type(Settings) ~= "table" then
        return DefaultSettings
    end
    for Index, Value in pairs(DefaultSettings) do
        if Settings[Index] == nil then
            Settings[Index] = Value
        end
    end
    return Settings
end

function Client:initialize(Settings)
    self.Settings = ParseSettings(Settings)
    self.API = API:new(self)
    self.Shards = {}
    self.Guilds = {}

    self.Intents = {}
end

function Client:Run(Token)
    coroutine.wrap(
        function()
            TypeWriter.Logger.Info("Loading " .. TypeWriter.LoadedPackages.duacord.Package.Name .. " " .. TypeWriter.LoadedPackages.duacord.Package.Version)

            self.Token = self.Settings.TokenPrefix .. Token
            
            TypeWriter.Logger.Info("Getting gateway information")

            self.GatewayInfo = self.API:GetGatewayBot()

            TypeWriter.Logger.Info(self.GatewayInfo.SessionStartLimit.Remaining .. "/" .. self.GatewayInfo.SessionStartLimit.Total .. " starts remaining")
            TypeWriter.Logger.Info("Starting " .. self.GatewayInfo.Shards ..  " shard(s)")

            for ShardId = 1, self.GatewayInfo.Shards do
                local Shard = Shard:new(self, ShardId - 1)
                table.insert(self.Shards, Shard)

                coroutine.wrap(Shard.Connect)(Shard)
            end
        end
    )()
end

function Client:GetGuild(Id)
    return self.Guilds[Id]
end

return Client