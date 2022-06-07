local UserCommand = Object:extend()

function UserCommand:initialize(Client, Data)
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
    self.Data.type = 2
end

function UserCommand:SetName(Name)
    self.Data.name = Name
end

function UserCommand:Register(Guild)
    self.Client:RegisterApplicationCommand(self:Export(), Guild)
end

function UserCommand:Export()
    return self.Data
end


return UserCommand