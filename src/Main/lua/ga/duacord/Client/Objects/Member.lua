local Member = Class:extend()

--#region Class methods
function Member:initialize(Client)
    self.Client = Client
end

function Member:BeforeInsert(Data)
    --p(Data)
end
function Member:OnInsert(Data)
    --for Index, Value in pairs(self) do print(Index, Value) end
end
--#endregion

return Member