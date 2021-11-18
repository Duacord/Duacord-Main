local Guild = Class:extend()




function Guild:initialize(Data, Client)

    self.Client = Client

    local Role = self.Client.Classes.Classes.Role
    local Member = self.Client.Classes.Classes.Role
    local Channel = self.Client.Classes.Classes.Channel

    self.Id = Data.id
    self.Name = Data.name
    self.Icon = Data.icon
    self.IconHash = Data.icon_hash
    self.Splash = Data.Splash
    self.DiscoverySplash = Data.discovery_splash
    self.Owner = Data.owner
    self.OwnerId = Data.owner_id
    self.Permissions = Data.permissions
    self.AfkChannelId = Data.afk_channel_id
    self.AfkTimeout = Data.afk_timeout
    self.WidgetEnabled = Data.widget_enabled
    self.WidgetChannelId = Data.widget_channel_id
    self.VerificationLevel = Data.verification_level
    self.DefaultMessageNotifications = Data.default_message_notifications
    self.ExplicitContentFilter = Data.explicit_content_filter
    self.Emojis = Data.emojis
    self.Features = Data.features
    self.MfaLevel = Data.mfa_level
    self.SystemChannelId = Data.system_channel_id
    self.SystemChannelFlags = Data.system_channel_flags
    self.RulesChannelId = Data.rules_channel_id
    self.JoinedAt = Data.joined_at
    self.Large = Data.large
    self.Unavailable = Data.unavailable
    self.MemberCount = Data.member_count
    self.VoiceStates = Data.voice_states
    self.Threads = Data.threads
    self.Presences = Data.presences
    self.MaxPresences = Data.max_presences
    self.MaxMembers = Data.max_members
    self.VanityUrlCode = Data.vanity_url_code
    self.Description = Data.description
    self.Banner = Data.banner
    self.PremiumTier = Data.premium_tier
    self.PremiumSubscriptionCount = Data.premium_subscription_count
    self.PreferredLocale = Data.preferred_locale
    self.PublicUpdatesChannelId = Data.public_updates_channel_id
    self.MaxVideoChannelUsers = Data.max_video_channel_users
    self.WelcomeScreen = Data.welcome_screen
    self.NsfwLevel = Data.nsfw_level
    self.StageInstances = Data.stage_instances
    self.Stickers = Data.stickers

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