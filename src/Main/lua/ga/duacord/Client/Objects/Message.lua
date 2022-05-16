local Message = Class:extend()

--#region Class methods
function Message:initialize(Client)
    self.Client = Client
end

function Message.meta:__tostring()
    return "Message: " .. self.Id
end

function Message:BeforeInsert(Data)
    if Data.GuildId ~= nil then
        self.Guild = self.Client:GetGuild(Data.GuildId)
        Data.GuildId = nil
        
        self.Channel = self.Guild:GetChannel(Data.ChannelId)
        Data.ChannelId = nil

        self.Member = self.Guild:GetMember(Data.Author.Id)
        Data.Member = nil

        self.Author = self.Member
        Data.Author = nil
    end
    p(Data)

end
--#endregion

return Message