local Role = Class:extend()

local Http = Import("ga.duacord.http.Main")
local HttpConstant = Import("ga.duacord.duacord.Constants.HTTP")

function Role:initialize(Data, Guild)
    self.Guild = Guild

    self.Id = Data.id
    self.Name = Data.name
    self.Color = Data.color
    self.Hoist = Data.Hoist
    self.Icon = Data.icon
    self.UnicodeEmoji = Data.unicode_emoji
    self.Position = Data.position
    self.Permissions = Data.permissions
    self.Managed = Data.managed
    self.Mentionable = Data.mentionable
    self.Tags = Data.tags


end

function Role:Edit(Data)
    Data = Data or {}

    local Response, Body = Http["coro-http"].request(
        "PATCH",
        HttpConstant.BaseUrl .. string.format(HttpConstant.Role, self.Guild.Id, self.Id),
        {
            self.Guild.Client.AuthHeader,
            {"X-Audit-Log-Reason", "sus"},
            {"Content-Type", "application/json"}
        },
        Json.encode({name = "tsetsts"})
    )

    p(Response)
    p(Body)
end


return Role