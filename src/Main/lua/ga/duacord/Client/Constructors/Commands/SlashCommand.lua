local SlashCommand = Object:extend()

local Constant = Import("ga.duacord.Client.API.Constant")

function SlashCommand:initialize(Client, Data)
    Data = Data or {}
    self.Client = Client
    self.Callback = Data.Callback or Data.callback or function () end
    Data.Callback = nil
    Data.callback = nil

    self.Client:On(
        "RawInteraction",
        function (Interaction, InteractionType)
            if InteractionType ~= Constant.ApplicationCommands.Type.ApplicationCommand then return end
            if Interaction.Data.Name ~= self.Data.name then return end

            self.Callback(Interaction, self)
        end
    )

    self.Data = Data
    self.Data.type = 1
    self.Data.name_localizations = self.Data.name_localizations or {}
    self.Data.description_localizations = self.Data.description_localizations or {}
    self.Data.options = self.Data.options or {}
    self.Data.dm_permission = false
end

function SlashCommand:SetName(Name)
    self.Data.name = string.lower(Name)
    return self
end

function SlashCommand:SetNameLocalization(Key, Name)
    self.Data.name_localizations[Key] = Name
    return self
end

function SlashCommand:SetDescription(Desc)
    self.Data.description = Desc
    return self
end

function SlashCommand:SetDescriptionLocalization(Key, Desc)
    self.Data.description_localizations[Key] = Desc
    return self
end

function SlashCommand:AddOption(Option)
    if type(Option.Export) == "function" then
        Option = Option:Export()
    end
    table.insert(self.Data.options, Option)
    return self
end

function SlashCommand:SetCallback(Fn)
    self.Callback = Fn
    return self
end

function SlashCommand:Register(Guild)
    self.Client:RegisterApplicationCommand(self:Export(), Guild)
end

function SlashCommand:Export()
    return self.Data
end

return SlashCommand