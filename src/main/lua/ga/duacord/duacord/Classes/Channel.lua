local Channel = Class:extend()

local HttpConstant = Import("ga.duacord.duacord.Constants.HTTP")


function Channel:initialize(Data, Guild)
    self.Guild = Guild

    self.Id = Data.id
    self.Type = Data.type
    self.Guild_id = Data.guild_id
    self.Position = Data.position
    self.Permission_overwrites = Data.permission_overwrites
    self.Name = Data.name
    self.Topic = Data.topic
    self.Nsfw = Data.nsfw
    self.Last_message_id = Data.last_message_id
    self.Bitrate = Data.bitrate
    self.User_limit = Data.user_limit
    self.Rate_limit_per_user = Data.rate_limit_per_user
    self.Recipients = Data.recipients
    self.Icon = Data.icon
    self.Owner_id = Data.owner_id
    self.Application_id = Data.application_id
    self.Parent_id = Data.parent_id
    self.Last_pin_timestamp = Data.last_pin_timestamp
    self.Rtc_region = Data.rtc_region
    self.Video_quality_mode = Data.video_quality_mode
    self.Message_count = Data.message_count
    self.Member_count = Data.member_count
    self.Thread_metadata = Data.thread_metadata
    self.Member = Data.member
    self.Default_auto_archive_duration = Data.default_auto_archive_duration
    self.Permissions = Data.permissions

    --p(self)
end

function Channel:Edit(Data, AuditReason)
    Data = Data or {}

    local Response, Body = self.Guild.Client.API:Request(
        "PATCH",
        HttpConstant.BASEURL .. string.format(HttpConstant.EndPoints.GUILD_MEMBER, self.Guild.Id, self.Id),
        Data,
        AuditReason
    )

    return Response.code == 200, Body.message
end


return Channel 