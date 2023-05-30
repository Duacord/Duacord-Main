local Member = Class:extend()

local UserClass = Import("ga.duacord.Client.Objects.User")

--#region Class methods
function Member:initialize(Client, Guild)
    self.Client = Client
    self.Guild = Guild
    self.Roles = {}
end

function Member.meta:__tostring()
    return "Member: " .. self.Id
end

function Member:BeforeInsert(Data)
    
    self.Id = Data.User.Id
    if Data.User ~= nil then
        local User = self.Client:GetUser(self.Id)
        if User == nil then
            User = UserClass:new(self.Client)
            self.Client.API:InsertTable(User, Data.User)
            self.Client.Users[User.Id] = User
        else
            User = self.Client:GetUser(self.Id)
        end
        self.User = User
    end
    Data.User = nil

    for Index, RoleId in pairs(Data.Roles) do
        local Role = self.Guild:GetRole(RoleId)
        if Role then
            table.insert(self.Roles, Role)
        end
    end
end
--#endregion

return Member