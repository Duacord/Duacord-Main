local User = Class:extend()

--#region Class methods
function User:initialize(Client)
    self.Client = Client
end

function User:BeforeInsert(Data)
end
--#endregion

return User