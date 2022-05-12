local Command = Object:extend()

function Command:initialize(Client, Data)
    Data = Data or {}
    self.Client = Client
    self.Callback = Data.Callback or Data.callback or function () end
    Data.Callback = nil
    Data.callback = nil

    self.Data = Data
    self.Data.type = 1
    --self.Data.name_localizations = self.Data.name_localizations or {}
    --self.Data.description_localizations = self.Data.description_localizations or {}
end

function Command:SetName(Name)
    self.Data.name = string.lower(Name)
    return self
end

function Command:SetNameLocalization(Key, Name)
    self.Data.name_localizations[Key] = Name
    return self
end

function Command:SetDescription(Desc)
    self.Data.description = Desc
    return self
end

function Command:SetDescriptionLocalization(Key, Desc)
    self.Data.description_localizations[Key] = Desc
    return self
end

function Command:SetCallback(Fn)
    self.Callback = Fn
    return self
end

function Command:Register(Guild)
    self.Client:RegisterApplicationCommand(self:Export(), Guild)
end

function Command:Export()
    return self.Data
end

return Command