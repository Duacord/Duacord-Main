local Client = Import("ga.duacord"):new(

)

--p(Client)

Client:Run(require("fs").readFileSync("Token"))

Client:On(
    "Loaded",
    function()
        p("Loaded")
        local Guild = Client:GetGuild("806963221469724723")
        local Channel = Guild:GetChannel("953030272151080961")
        Channel:Send(
            {
                Content = "First message from Lua",
                Components = {
                    {
                        type = 1,
                        components = {
                            {
                                type = 2,
                                style = 1,
                                label = "Hoi",
                                custom_id = "werw"
                            }
                        }
                    }
                    
                }
            }
        )
        print("Done")
    end
)