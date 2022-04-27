local Client = Import("nl.cubic-inc.logger.Main"):extend()

Client.Constants = {
    EndPoints = Import("ga.duacord.duacord.Client.Constant.EndPoints"),
    API = Import("ga.duacord.duacord.Client.Constant.API"),
    Opcodes = Import("ga.duacord.duacord.Client.Constant.Opcodes")
}

Client.Classes = {
    API = Import("ga.duacord.duacord.Client.SubClasses.API.API"),
    Shard = Import("ga.duacord.duacord.Client.SubClasses.Shard"),
    EventHandler = Import("ga.duacord.duacord.Client.SubClasses.EventHandler"),

    Objects = {
        Channel = Import("ga.duacord.duacord.Client.SubClasses.Objects.Channel"),
        Guild = Import("ga.duacord.duacord.Client.SubClasses.Objects.Guild"),
        Member = Import("ga.duacord.duacord.Client.SubClasses.Objects.Member"),
        Message = Import("ga.duacord.duacord.Client.SubClasses.Objects.Message"),
        Role = Import("ga.duacord.duacord.Client.SubClasses.Objects.Role"),
        User = Import("ga.duacord.duacord.Client.SubClasses.Objects.User")
    }
}

function Client:initialize(Settings)
    self.API = self.Classes.API:new(self)
    self.EventHandler = self.Classes.EventHandler:new(self)
    self.Shards = {}
    self.Guilds = {}

    self.DebugMode = Settings.Debug or false
end

function Client:Run(Token)
    self.Token = "Bot " .. Token
    local GatewayInfo = self.API:GatewayBot()

    self:Info("Duacord " .. LoadedPackages["duacord-main"].PackageInfo.Version)
    self:Info(GatewayInfo.shards .. " Shards")
    self:Info(
        string.format(
            "%s/%s Starts Remaining",
            GatewayInfo.session_start_limit.remaining -1,
            GatewayInfo.session_start_limit.total
        )
    )

    for i = 1, GatewayInfo.shards do
        self.Shards[i] = self.Classes.Shard:new(self, i - 1)
    end

    self:Info("Connecting to discord...")

    for Index, Shard in pairs(self.Shards) do
        Shard:Connect(GatewayInfo)
    end
end

return Client