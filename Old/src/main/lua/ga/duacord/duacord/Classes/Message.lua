local Message = Class:extend()
local ReMap = Import("ga.duacord.duacord.API.ReMap")

local HttpConstant = Import("ga.duacord.duacord.Constants.HTTP")

Message.ClassMap = {
    ["Id"] = "id",
    ["Type"] = "type",
    ["Guild_id"] = "guild_id",
    ["Position"] = "position",
    ["Permission_overwrites"] = "permission_overwrites",
    ["Name"] = "name",
    ["Topic"] = "topic",
    ["Nsfw"] = "nsfw",
    ["Last_message_id"] = "last_message_id",
    ["Bitrate"] = "bitrate",
    ["User_limit"] = "user_limit",
    ["Rate_limit_per_user"] = "rate_limit_per_user",
    ["Recipients"] = "recipients",
    ["Icon"] = "icon",
    ["Owner_id"] = "owner_id",
    ["Application_id"] = "application_id",
    ["Parent_id"] = "parent_id",
    ["Last_pin_timestamp"] = "last_pin_timestamp",
    ["Rtc_region"] = "rtc_region",
    ["Video_quality_mode"] = "video_quality_mode",
    ["Message_count"] = "message_count",
    ["Member_count"] = "member_count",
    ["Thread_metadata"] = "thread_metadata",
    ["Member"] = "member",
    ["Default_auto_archive_duration"] = "default_auto_archive_duration",
    ["Permissions"] = "permissions",
}

function Message:initialize(Data, Guild)
    self.Guild = Guild
    self.Client = Guild.Client

    ReMap(self, Data)

end

function Message:Edit(Data, AuditReason)
    Data = Data or {}

    local Response, Body = self.Guild.Client.API:Request(
        "PATCH",
        HttpConstant.BASEURL .. string.format(HttpConstant.EndPoints.CHANNEL, self.Id),
        Data,
        AuditReason
    )

    return Response.code == 200, Body.message
end




return Message