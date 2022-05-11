local Client = Import("ga.duacord"):new(

)

--p(Client)

Client:Run(require("fs").readFileSync("Token"))

Client:On(
    "Loaded",
    function()
        p("Loaded")
        local Guild = Client:GetGuild("783625199702245436")
        local Channel = Guild:GetChannel("783731240138047529")
        --Channel:Send("First message from Lua")
        print("Done")
    end
)