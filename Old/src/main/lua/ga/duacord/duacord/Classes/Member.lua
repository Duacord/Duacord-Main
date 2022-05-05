local Member = Class:extend()

local HttpConstant = Import("ga.duacord.duacord.Constants.HTTP")


function Member:initialize(Data, Guild)
    self.Guild = Guild
    self.Client = Guild.Client
    
    self.Nick = Data.nick
    self.Avatar = Data.avatar
    self.JoinedAt = Data.joined_at
    self.PremiumSince = Data.premium_since
    self.Deaf = Data.deaf
    self.Mute = Data.mute
    self.Pending = Data.pending
    self.Permissions = Data.permissions


    self.User = self.Client.Classes.Classes.User:new(Data.user, self)

    self.Roles = {}
    for Index, RoleId in pairs(Data.roles) do
        self.Roles[RoleId] = self.Guild:GetRole(RoleId)
    end


end

function Member:Edit(Data, AuditReason)
    Data = Data or {}

    local Response, Body = self.Guild.Client.API:Request(
        "PATCH",
        HttpConstant.BASEURL .. string.format(HttpConstant.EndPoints.GUILD_MEMBER, self.Guild.Id, self.Id),
        Data,
        AuditReason
    )

    return Response.code == 200, Body.message
end

function Member:SetNick(Name, Reason)
    return self:Edit({nick = Name}, Reason)
end

function Member:SetMute(Enable, Reason)
    return self:Edit({mute = Enable}, Reason)
end

function Member:SetDeaf(Enable, Reason)
    return self:Edit({deaf = Enable}, Reason)
end

function Member:Move(ChannelId, Reason)
    return self:Edit({channel_id = ChannelId}, Reason)
end

return Member 