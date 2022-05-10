local Guild = Class:extend()

local MemberClass = Import("ga.duacord.Client.Objects.Member")

--#region Class methods
function Guild:initialize(Client)
    self.Client = Client
    self.Members = {}
    self.Roles = {}
end

function Guild:BeforeInsert(Data)
    Data.Region = nil
    if Data.Members then
        for Index, MemberData in pairs(Data.Members) do

            local Member = MemberClass:new(self.Client, self)
            self.Client.API:InsertTable(Member, MemberData)
            self.Members[Member.User.Id] = Member

        end
        Data.Members = nil
    end
end
--#endregion

--#region Object Getters
function Guild:GetMember()
    
end

function Guild:GetRole()
    
end
--#endregion

function Guild:SetName(Name)
    
end

return Guild