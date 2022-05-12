local Member = Class:extend()

local UserClass = Import("ga.duacord.Client.Objects.User")

--#region Class methods
function Member:initialize(Client, Guild)
    self.Client = Client
    self.Guild = Guild
    self.User = UserClass:new(Client)
    self.Roles = {}
end

function Member:BeforeInsert(Data)
    
    self.Id = Data.User.Id
    self.Client.API:InsertTable(self.User, Data.User)
    Data.User = nil

    for Index, RoleId in pairs(Data.Roles) do
        local Role = self.Guild:GetRole(RoleId)
        if Role then
            table.insert(self.Roles, Role)
        end
    end
end
function Member:OnInsert(Data)
    --for Index, Value in pairs(self) do print(Index, Value) end
end
--#endregion

return Member