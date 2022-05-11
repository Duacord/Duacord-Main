local Role = Class:extend()

--#region Class methods
function Role:initialize(Client, Guild)
    self.Client = Client
    self.Guild = Guild
end

function Role:BeforeInsert(Data)
    --p(Data)
end
function Role:OnInsert(Data)
    --for Index, Value in pairs(self) do print(Index, Value) end
end
--#endregion

return Role