local Option = Object:extend()

local Constant = Import("ga.duacord.Client.API.Constant")

function Option:initialize(Client, Data)
    Data = Data or {}
    self.Client = Client

    self.Data = Data or {}
    self.Data.channel_types = self.Data.channel_types or {}
    self.Data.options = self.Data.options or {}
    self.Data.choices = self.Data.choices or {}
    self.Data.name_localizations = self.Data.name_localizations or {}
    self.Data.description_localizations = self.Data.description_localizations or {}
end

function Option:SetType(Type)
    if type(Type) == "string" then
        self.Data.type = Constant.ApplicationCommands.Option[Type]
    end
    self.Data.type = Type
end

--#region Name
function Option:SetName(Name)
    self.Data.name = Name
    return self
end

function Option:SetNameLocalization(Key, Name)
    self.Data.name_localizations[Key] = Name
    return self
end
--#endregion

--#region Desc
function Option:SetDescription(Desc)
    self.Data.description = Desc
    return self
end

function Option:SetDescriptionLocalization(Key, Desc)
    self.Data.description_localizations[Key] = Desc
    return self
end
--#endregion

function Option:SetRequired(Bool)
    self.Data.required = Bool
    return self
end

function Option:AddChoice(Name, Value, Loc)
    local Choice = {}
    Choice.name = Name
    Choice.value = Value
    Choice.localization = Loc
    table.insert(self.Data.choices, Choice)
    return self
end

function Option:AddOption(OptionObject)
    table.insert(self.Data.options, OptionObject:Export())
    return self
end

--#region Channel allow
function Option:SetChannelType(Type, Bool)
    if type(Type) == "string" then
        Type = Constant.ChannelTypes[Type]
    end
    if Bool == true then
        self.Data.channel_types[Type] = Type
    else
        self.Data.channel_types[Type] = nil
    end
end
--#endregion

function Option:SetClamp(Min, Max)
    self.Data.min_value = Min
    self.Data.max_value = Max
    return self
end

function Option:AllowAutoComplete(Bool)
    self.Data.autocomplete = Bool
    return self
end

function Option:Export()
    return self.Data
end

return Option