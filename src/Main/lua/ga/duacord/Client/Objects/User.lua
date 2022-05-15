local User = Class:extend()

--#region Class methods
function User:initialize(Client)
    self.Client = Client
end

function User.meta:__tostring()
    return "User: " .. self.Id
end

function User:BeforeInsert(Data)
end
--#endregion

return User