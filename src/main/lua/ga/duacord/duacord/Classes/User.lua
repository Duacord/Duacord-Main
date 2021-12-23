local User = Class:extend()
local ReMap = Import("ga.duacord.duacord.API.ReMap")

local HttpConstant = Import("ga.duacord.duacord.Constants.HTTP")

User.ClassMap = {
    ["Id"]              = "id",
    ["Username"]        = "username",
    ["Discriminator"]   = "discriminator",
    ["Avatar"]          = "avatar",
    ["Bot"]             = "bot",
    ["System"]          = "system",
    ["MfaEnabled"]      = "mfa_enabled",
    ["Banner"]          = "banner",
    ["AccentColor"]     = "accent_color",
    ["Locale"]          = "locale",
    ["Flags"]           = "flags",
    ["PremiumType"]     = "premium_type",
    ["PublicFlags"]     = "public_flags",
}

function User:initialize(Data, Member)
    self.Member = Member
    self.Client = self.Member.Client

    ReMap(self, Data)
end

function User:Edit(Data, AuditReason)
    Data = Data or {}

    local Response, Body = self.Guild.Client.API:Request(
        "PATCH",
        HttpConstant.BASEURL .. string.format(HttpConstant.EndPoints.GUILD_MEMBER, self.Guild.Id, self.Id),
        Data,
        AuditReason
    )

    return Response.code == 200, Body.message
end


return User 