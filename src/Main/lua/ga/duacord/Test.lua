local Client = Import("ga.duacord"):new(

)

local TextInput = Client.Constructors.Components.TextInput()
TextInput:SetLabel("Label"):SetTitle("Title"):SetRequired(true):SetStyle("Short"):SetId("TextInput")

local TextInput2 = Client.Constructors.Components.TextInput()
TextInput2:SetLabel("Label2"):SetTitle("Title2"):SetRequired(true):SetStyle("Paragraph"):SetId("TextInput2")


local Modal = Client.Constructors.Modal.Modal()
Modal:SetTitle("TestModal"):AddComponent(TextInput):AddComponent(TextInput2):SetCallback(function (Interaction)
    p(Interaction.Data)
    Interaction:Reply("Label " .. Interaction.Data.TextInput.Value .. " Label2 " .. Interaction.Data.TextInput2.Value)
end)

local Command = Client.Constructors.SlashCommands.Command()
Command:SetName("Hello")
Command:SetDescription("Hello command")
Command:SetCallback(function (Interaction)
    Interaction:ShowModal(Modal)
end)
Command:Register()

do
    local InputText = Client.Constructors.Components.TextInput()
    InputText:SetLabel("Message")
    InputText:SetTitle("Message")
    InputText:SetRequired(true)
    InputText:SetStyle("Paragraph")
    InputText:SetId("Message")


    local InputModal = Client.Constructors.Modal.Modal()
    InputModal:SetTitle("Input message")
    InputModal:AddComponent(InputText)
    InputModal:SetCallback(function (Interaction)
        Interaction:Reply(Interaction.Data.Message.Value)
    end)
    InputModal.Data.custom_id = "InputModal"

    local SayCommand = Client.Constructors.SlashCommands.Command()
    SayCommand:SetName("Say")
    SayCommand:SetDescription("Say command")
    SayCommand:SetCallback(function (Interaction)
        Interaction:ShowModal(InputModal)
    end)
    SayCommand:Register()
end

Client:Run(require("fs").readFileSync("Token"))

Client:On(
    "Loaded",
    function()
        p("Loaded")
        local Guild = Client:GetGuild("806963221469724723")
        local Channel = Guild:GetChannel("953030272151080961")
        Channel:Send(
            {
                content = "Hallo",
                
            }
        )
        print("Done")


        Client:SyncApplicationCommands()

    end
)

Client:On("MessageCreate", function (Message)
    --for Index, Value in pairs(Message) do print(Index, Value) end
end)