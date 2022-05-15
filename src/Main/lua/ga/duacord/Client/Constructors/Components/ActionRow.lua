local ActionRow = Object:extend()

local Constant = Import("ga.duacord.Client.API.Constant")

function ActionRow:initialize(Client, Data)
    Data = Data or {}
    self.Client = Client

    self.Data = Data
    self.Data.type = 1
    self.Data.components = {}
end

function ActionRow:AddComponent(Component)
    if type(Component.Export) == "function" then
        Component = Component:Export()
    end
    table.insert(self.Data.components, Component)
    return self
end

function ActionRow:Export()
    return self.Data
end

return ActionRow