local Role = Class:extend()

--#region Class methods
function Role:initialize(Client, Guild)
    self.Client = Client
    self.Guild = Guild
end

function Role.meta:__tostring()
    return "Role: " .. self.Id
end

function Role:BeforeInsert(Data)
end
--#endregion

return Role