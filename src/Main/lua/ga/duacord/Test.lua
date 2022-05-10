local Client = Import("ga.duacord"):new(

)

--p(Client)

Client:Run(require("fs").readFileSync("Token"))

Client:On(
    "Loaded",
    function()
        p("Loaded")
        
    end
)