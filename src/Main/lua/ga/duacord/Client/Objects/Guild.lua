local Guild = Class:extend()

local ChannelClass = Import("ga.duacord.Client.Objects.Channel")
local MemberClass = Import("ga.duacord.Client.Objects.Member")
local RoleClass = Import("ga.duacord.Client.Objects.Role")

--#region Class methods
function Guild:initialize(Client)
    self.Client = Client
    self.Members = {}
    self.Roles = {}
    self.Channels = {}
end

function Guild:BeforeInsert(Data)
    Data.Region = nil
    Data.Presences = nil

    if Data.Members then
        for Index, MemberData in pairs(Data.Members) do

            local Member = MemberClass:new(self.Client, self)
            self.Client.API:InsertTable(Member, MemberData)
            self.Members[Member.User.Id] = Member

        end
        Data.Members = nil
    end

    if Data.Roles then
        for Index, RoleData in pairs(Data.Roles) do

            local Role = RoleClass:new(self.Client, self)
            self.Client.API:InsertTable(Role, RoleData)
            self.Roles[Role.Id] = Role

        end
        Data.Roles = nil
    end

    if Data.Channels then
        for Index, ChannelData in pairs(Data.Channels) do

            local Channel = ChannelClass:new(self.Client, self, "Guild")
            self.Client.API:InsertTable(Channel, ChannelData)
            self.Channels[Channel.Id] = Channel

        end
        Data.Channels = nil
    end
end
--#endregion

--#region Object Getters
function Guild:GetMember(Id)
    return self.Members[Id]
end

function Guild:GetRole(Id)
    return self.Roles[Id]
end

function Guild:GetChannel(Id)
    return self.Channels[Id]
end
--#endregion

function Guild:SetName(Name)
    
end

return Guild