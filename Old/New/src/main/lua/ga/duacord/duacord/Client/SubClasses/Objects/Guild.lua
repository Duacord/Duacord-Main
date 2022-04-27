local Guild = Class:extend()

Guild.ClassMap = {
    ["Id"]                              = "id",
    ["Name"]                            = "name",
    ["Icon"]                            = "icon",
    --["IconHash"]                        = "icon_hash",
    ["Splash"]                          = "splash",
    ["DiscoverySplash"]                 = "discovery_splash",
    ["Owner"]                           = "owner",
    ["OwnerId"]                         = "owner_id",
    ["Permissions"]                     = "permissions",
    ["AfkChannelId"]                    = "afk_channel_id",
    ["AfkTimeout"]                      = "afk_timeout",
    ["WidgetEnabled"]                   = "widget_enabled",
    ["WidgetChannelId"]                 = "widget_channel_id",
    ["VerificationLevel"]               = "verification_level",
    ["DefaultMessageNotifications"]     = "default_message_notifications",
    ["ExplicitContentFilter"]           = "explicit_content_filter",
    ["Emojis"]                          = "emojis",
    ["Features"]                        = "features",
    ["MfaLevel"]                        = "mfa_level",
    ["SystemChannelId"]                 = "system_channel_id",
    ["SystemChannelFlags"]              = "system_channel_flags",
    ["RulesChannelId"]                  = "rules_channel_id",
    ["JoinedAt"]                        = "joined_at",
    ["Large"]                           = "large",
    ["Unavailable"]                     = "unavailable",
    ["MemberCount"]                     = "member_count",
    ["VoiceStates"]                     = "voice_states",
    ["Threads"]                         = "threads",
    ["Presences"]                       = "presences",
    ["MaxPresences"]                    = "max_presences",
    ["MaxMembers"]                      = "max_members",
    ["VanityUrlCode"]                   = "vanity_url_code",
    ["Description"]                     = "description",
    ["Banner"]                          = "banner",
    ["PremiumTier"]                     = "premium_tier",
    ["PremiumSubscriptionCount"]        = "premium_subscription_count",
    ["PreferredLocale"]                 = "preferred_locale",
    ["PublicUpdatesChannelId"]          = "public_updates_channel_id",
    ["MaxVideoChannelUsers"]            = "max_video_channel_users",
    ["WelcomeScreen"]                   = "welcome_screen",
    ["NsfwLevel"]                       = "nsfw_level",
    ["StageInstances"]                  = "stage_instances",
    ["Stickers"]                        = "stickers",
}

function Guild:initialize(Data, Client)

    self.Client = Client

    local Role = self.Client.Classes.Objects.Role
    local Member = self.Client.Classes.Objects.Member
    local Channel = self.Client.Classes.Objects.Channel


    self.Client.API:RemapClass(self, Data)


    self.Roles = {}
    for Index, NewRole in pairs(Data.roles) do
        self.Roles[NewRole.id] = Role:new(NewRole, self)
    end

    self.Members = {}
    for Index, NewMember in pairs(Data.members) do
        self.Members[NewMember.user.id] = Member:new(NewMember, self)
    end

    self.Channels = {} 
    for Index, NewChannel in pairs(Data.channels) do
        self.Channels[NewChannel.id] = Channel:new(NewChannel, self)
    end

    for i, v in pairs(self.Roles) do print(i,v) end

end

function Guild.meta:__tostring()
    return "Guild: " .. self.Id .. " (" .. self.Name .. ")"
end

function Guild:GetRole(Id)
    return self.Roles[Id]
end

function Guild:GetMember(Id)
    return self.Members[Id]
end

function Guild:GetChannel(Id)
    return self.Channels[Id]
end

return Guild