local Role = Class:extend()
local ReMap = Import("ga.duacord.duacord.API.ReMap")

local HttpConstant = Import("ga.duacord.duacord.Constants.HTTP")

Role.ClassMap = {
    ["Id"] = "id",
    ["Name"] = "name",
    ["Color"] = "color",
    ["Hoist"] = "Hoist",
    ["Icon"] = "icon",
    ["UnicodeEmoji"] = "unicode_emoji",
    ["Position"] = "position",
    ["Permissions"] = "permissions",
    ["Managed"] = "managed",
    ["Mentionable"] = "mentionable",
    ["Tags"] = "tags",
}

function Role:initialize(Data, Guild)
    self.Guild = Guild
    self.Client = self.Guild.Client

    self.Client.API:RemapClass(self, Data)
end

function Role.meta:__tostring()
    return "Role: " .. self.Id .. " (" .. self.Name .. ")"
end

function Role:Update(Data)
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

function Role:Edit(Data, AuditReason)
    Data = Data or {}

    local Response, Body = self.Guild.Client.API:Request(
        "PATCH",
        HttpConstant.BASEURL .. string.format(HttpConstant.EndPoints.GUILD_ROLE, self.Guild.Id, self.Id),
        Data,
        AuditReason
    )

    return Response.code == 200, Body.message
end

function Role:Delete(Reason)
    local Response, Body = self.Guild.Client.API:Request(
        "DELETE",
        HttpConstant.BASEURL .. string.format(HttpConstant.EndPoints.GUILD_ROLE, self.Guild.Id, self.Id),
        {},
        Reason
    )

    Body = Body or {}
    return Response.code == 204, Body.message

end

function Role:SetMentioning(Enable, Reason)
    return self:Edit({mentionable = Enable}, Reason)
end

function Role:SetHoist(Enable, Reason)
    return self:Edit({hoist = Enable}, Reason)
end


function Role:SetColor(Color, Reason)
    return self:Edit({color = Color}, Reason)
end

function Role:SetName(Name, Reason)
    return self:Edit({name = Name}, Reason)
end



return Role 