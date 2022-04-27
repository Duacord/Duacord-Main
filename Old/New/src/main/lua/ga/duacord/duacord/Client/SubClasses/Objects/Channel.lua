local Channel = Class:extend()

local HttpConstant = Import("ga.duacord.duacord.Constants.HTTP")

Channel.ClassMap = {
    ["Id"]                              = "id",
    ["Type"]                            = "type",
    ["Position"]                        = "position",
    ["PermissionOverwrites"]            = "permission_overwrites",
    ["Name"]                            = "name",
    ["Topic"]                           = "topic",
    ["Nsfw"]                            = "nsfw",
    ["LastMessageId"]                   = "last_message_id",
    ["Bitrate"]                         = "bitrate",
    ["UserLimit"]                       = "user_limit",
    ["RateLimitPerUser"]                = "rate_limit_per_user",
    ["Recipients"]                      = "recipients",
    ["Icon"]                            = "icon",
    ["OwnerId"]                         = "owner_id",
    ["ApplicationId"]                   = "application_id",
    ["ParentId"]                        = "parent_id",
    ["LastPinTimestamp"]                = "last_pin_timestamp",
    ["RtcRegion"]                       = "rtc_region",
    ["VideoQualityMode"]                = "video_quality_mode",
    ["MessageCount"]                    = "message_count",
    ["MemberCount"]                     = "member_count",
    ["ThreadMetadata"]                  = "thread_metadata",
    ["Member"]                          = "member",
    ["DefaultAutoArchiveDuration"]      = "default_auto_archive_duration",
    ["Permissions"]                     = "permissions",
}

function Channel:initialize(Data, Guild)
    self.Guild = Guild
    self.Client = Guild.Client

    self.Client.API:RemapClass(self, Data)
end

function Channel:Edit(Data, AuditReason)
    Data = Data or {}

    local Response, Body = self.Guild.Client.API:Request(
        "PATCH",
        HttpConstant.BASEURL .. string.format(HttpConstant.EndPoints.CHANNEL, self.Id),
        Data,
        AuditReason
    )

    return Response.code == 200, Body.message
end

function Channel:SetTopic(Name, AuditReason)
    return self:Edit({topic = Name})
end

function Channel:SetName(Name, AuditReason)
    return self:Edit({name = Name})
end

function Channel:Send(Data)
    local Response, Body = self.Guild.Client.API:Request(
        "POST",
        HttpConstant.BASEURL .. string.format(HttpConstant.EndPoints.CHANNEL_MESSAGES, self.Id),
        Data
    )

    return Response.code == 200, Body.message
end


return Channel 