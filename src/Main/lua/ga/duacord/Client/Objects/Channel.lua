local Channel = Class:extend()

--#region Class methods
function Channel:initialize(Client, Parent, ParentType)
    self.Client = Client
    self[ParentType] = Parent
end

function Channel.meta:__tostring()
    return "Channel: " .. self.Id
end

function Channel:BeforeInsert(Data)
end
--#endregion

function Channel:Send(Data)
    if type(Data) == "string" then
        Data = {
            Content = Data
        }
    end

    self.Client.API:CreateMessage(
        self.Id,
        Data
    )
end

return Channel