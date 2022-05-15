local Client = Import("ga.corebyte.BetterEmitter"):extend()

local API = Import("ga.duacord.Client.API")
local Shard = Import("ga.duacord.Client.SubClasses.Shard")
local Constructors = Import("ga.duacord.Client.Constructors")

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
    self.ApplicationCommands = {}
    self.ApplicationCommands.Global = {}
    self.ApplicationCommands.Guild = {}

    self.Intents = {}

    -- Constructors
    Client.Constructors = Constructors(self)
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

            local ShardsReady = 0

            for ShardId = 1, self.GatewayInfo.Shards do
                local Shard = Shard:new(self, ShardId - 1)
                table.insert(self.Shards, Shard)

                Shard:Once(
                    "GuildsLoaded",
                    function()
                        TypeWriter.Logger.Info("Shard " .. Shard.Id .. ": Fully loaded")
                        ShardsReady = ShardsReady + 1
                        if ShardsReady == self.GatewayInfo.Shards then
                            TypeWriter.Logger.Info("Fully loaded")
                            self:Emit("Loaded")
                        end
                    end
                )

                coroutine.wrap(Shard.Connect)(Shard)
            end
        end
    )()
end

function Client:RegisterApplicationCommand(CommandData, Guild)
    if Guild then
        if self.ApplicationCommands.Guild[CommandData.type] == nil then
            self.ApplicationCommands.Guild[CommandData.type] = {}
        end
        self.ApplicationCommands.Guild[CommandData.type][CommandData.name] = CommandData
    else
        if self.ApplicationCommands.Global[CommandData.type] == nil then
            self.ApplicationCommands.Global[CommandData.type] = {}
        end
        self.ApplicationCommands.Global[CommandData.type][CommandData.name] = CommandData
    end
    
end

function Client:SyncApplicationCommands()
    self:SyncGlobalApplicationCommands()
    self:SyncGuildApplicationCommands()
end

function Client:SyncGlobalApplicationCommands()
    local SendData = {}
    for CommandType, ApplicationCommandList in pairs(self.ApplicationCommands.Global) do
        for CommandName, CommandData in pairs(ApplicationCommandList) do
            table.insert(SendData, CommandData)
        end
    end
    --p(SendData)
    self.API:BulkOverwriteGlobalApplicationCommands(SendData)
end

function Client:SyncGuildApplicationCommands()
    
end

function Client:GetGuild(Id)
    return self.Guilds[Id]
end

return Client