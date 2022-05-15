local TextInput = Object:extend()

local Constant = Import("ga.duacord.Client.API.Constant")

function TextInput:initialize(Client, Data)
    Data = Data or {}
    self.Client = Client

    self.Data = Data
    self.Data.type = 4
end

function TextInput:SetId(Id)
    self.Data.custom_id = Id
    return self
end

function TextInput:SetStyle(Style)
    if type(Style) == "string" then
        Style = Constant.MessageComponents.TextInput.Style[Style]
    end
    self.Data.style = Style
    return self
end

function TextInput:SetLabel(Label)
    self.Data.label = Label
    return self
end

function TextInput:SetTitle(Name)
    self.Data.title = Name
    return self
end

function TextInput:SetClamp(Min, Max)
    self.Data.min_length = Min
    self.Data.max_length = Max
    return self
end

function TextInput:SetRequired(Bool)
    self.Data.required = Bool
    return self
end

function TextInput:SetValue(Value)
    self.Data.value = Value
    return self
end

function TextInput:SetPlaceholder(PlaceHolder)
    self.Data.placeholder = PlaceHolder
    return self
end

function TextInput:Export()
    return self.Data
end

return TextInput