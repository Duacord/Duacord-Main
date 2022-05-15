local Client = Import("ga.duacord"):new(

)

local TextInput = Client.Constructors.Components.TextInput()
TextInput:SetLabel("Label"):SetTitle("Title"):SetRequired(true):SetStyle("Short"):SetId("TextInput")

local TextInput2 = Client.Constructors.Components.TextInput()
TextInput2:SetLabel("Label2"):SetTitle("Title2"):SetRequired(true):SetStyle("Paragraph"):SetId("TextInput2")


local Modal = Client.Constructors.Modal.Modal()
Modal:SetTitle("TestModal"):AddComponent(TextInput):AddComponent(TextInput2):SetCallback(function (Interaction)
    --p(Interaction.Data)
end)

local Command = Client.Constructors.SlashCommands.Command()
Command:SetName("Hello")
Command:SetDescription("Hello command")
Command:SetCallback(function (Interaction)
    Interaction:ShowModal(Modal)
end)
Command:Register()



Client:Run(require("fs").readFileSync("Token"))

Client:On(
    "Loaded",
    function()
        p("Loaded")
        local Guild = Client:GetGuild("806963221469724723")
        local Channel = Guild:GetChannel("953030272151080961")
        print("Done")


        Client:SyncApplicationCommands()

    end
)