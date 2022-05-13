local Client = Import("ga.duacord"):new(

)

local Command = Client.Constructors.SlashCommands.Command()
Command:SetName("Hello")
Command:SetDescription("Hello command")
Command:SetCallback(function ()
    
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