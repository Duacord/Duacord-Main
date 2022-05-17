local Button = Object:extend()

local Constant = Import("ga.duacord.Client.API.Constant")

function Button:initialize(Client, Data)
    Data = Data or {}
    self.Client = Client
    self.Callback = Data.Callback or Data.callback or function () end
    Data.Callback = nil
    Data.callback = nil

    self.Data = Data
    self.Data.type = 2

    self.Client:On(
        "RawInteraction",
        function (Interaction, InteractionType)
            if InteractionType ~= Constant.ApplicationCommands.Type.MessageComponent then return end
            for Index, Value in pairs(Interaction) do print(Index, Value) end
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

function Button:SetCallback(Fn)
    self.Callback = Fn
    return self
end

function Button:SetStyle(Style)
    if type(Style) == "string" then
        Style = Constant.MessageComponents.Button.Style[Style]
    end
    self.Data.style = Style
    return self
end

function Button:SetLabel(Label)
    self.Data.label = Label
    return self
end

function Button:SetEmoji(Name, Id, Animated)
    self.Data.emoji = {
        name = Name,
        id = Id,
        animated = Animated
    }
    return self
end

function Button:SetId(Id)
    self.Data.custom_id = Id
    return self
end

function Button:SetUrl(Url)
    self.Data.url = Url
    self:SetStyle("Link")
    return self
end

function Button:SetToggle(Bool)
    self.Data.disabled = Bool
    return self
end

function Button:Export()
    return self.Data
end

return Button