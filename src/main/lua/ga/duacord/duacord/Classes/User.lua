local User = Class:extend()

local HttpConstant = Import("ga.duacord.duacord.Constants.HTTP")


function User:initialize(Data, Member)
    self.Member = Member

    self.Id = Data.id
    self.Username = Data.username
    self.Discriminator = Data.discriminator
    self.Avatar = Data.avatar
    self.Bot = Data.bot
    self.System = Data.system
    self.MfaEnabled = Data.mfa_enabled
    self.Banner = Data.banner
    self.AccentColor = Data.accent_color
    self.Locale = Data.locale
    self.Flags = Data.flags
    self.PremiumType = Data.premium_type
    self.PublicFlags = Data.public_flags


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