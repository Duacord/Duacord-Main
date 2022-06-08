local Client = Import("ga.duacord"):new(

)

local Modal
do
    local TextInput = Client.Constructors.Components.TextInput()
    TextInput:SetLabel("Label"):SetTitle("Title"):SetRequired(true):SetStyle("Short"):SetId("TextInput")

    local TextInput2 = Client.Constructors.Components.TextInput()
    TextInput2:SetLabel("Label2"):SetTitle("Title2"):SetRequired(true):SetStyle("Paragraph"):SetId("TextInput2")


    Modal = Client.Constructors.Modal.Modal()
    Modal:SetId("TestModal")
    Modal:SetTitle("TestModal"):AddComponent(TextInput):AddComponent(TextInput2):SetCallback(function (Interaction)
        Interaction:Reply("Label " .. Interaction.Data.TextInput.Value .. " Label2 " .. Interaction.Data.TextInput2.Value)
    end)
end

do
    local Command = Client.Constructors.Commands.SlashCommand()
    Command:SetName("Hello")
    Command:SetDescription("Hello command")
    Command:SetCallback(function (Interaction)
        Interaction:ShowModal(Modal)
    end)
    Command:Register()
end

do
    local UserCommand = Client.Constructors.Commands.UserCommand()
    UserCommand:SetName("Hello")
    UserCommand:SetCallback(function (Interaction)
        Interaction:Reply("Hi")
    end)
    UserCommand:Register()
end


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

    local SayCommand = Client.Constructors.Commands.SlashCommand()
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
        local Guild = Client:GetGuild("783625199702245436")
        local Channel = Guild:GetChannel("783731240138047529")
        Channel:Send(
            Client.Constructors.Message.Message():SetContent("Hello World!")
            :AddComponent(
                Client.Constructors.Components.Button():SetLabel("Hoi"):SetId("HoiButton"):SetCallback(function (Interaction)
                    Interaction:Reply("Hoi")
                end)
            )
        )
        print("Done")


        Client:SyncApplicationCommands()

    end
)

Client:On("MessageCreate", function (Message)
    --for Index, Value in pairs(Message) do print(Index, Value) end
end)