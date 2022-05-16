local Modal = Object:extend()

local Constant = Import("ga.duacord.Client.API.Constant")

function Modal:initialize(Client, Data)
    Data = Data or {}
    self.Client = Client
    self.Callback = Data.Callback or Data.callback or function () end
    Data.Callback = nil
    Data.callback = nil

    self.Data = Data
    self.Data.components = {}
    self.Data.custom_id = Client.API:GenerateCustomId()

    self.Client:On(
        "RawInteraction",
        function (Interaction, InteractionType)
            if InteractionType ~= Constant.ApplicationCommands.Type.ModalSubmit then return end
            if Interaction.Data.CustomId ~= self.Data.custom_id then return end

            local NewData = {}
            for Index, Component in pairs(Interaction.Data.Components) do
                NewData[Component.Components[1].CustomId] = Component.Components[1]
            end
            Interaction.Data = NewData

            self.Callback(Interaction, self)
        end
    )
end

function Modal:SetTitle(Name)
    self.Data.title = Name
    return self
end

function Modal:AddComponent(Component)
    if type(Component.Export) == "function" then
        Component = Component:Export()
    end
    table.insert(self.Data.components, self.Client.Constructors.Components.ActionRow():AddComponent(Component):Export())
    return self
end

function Modal:SetCallback(Fn)
    self.Callback = Fn
    return self
end

function Modal:Export()
    return self.Data
end

return Modal