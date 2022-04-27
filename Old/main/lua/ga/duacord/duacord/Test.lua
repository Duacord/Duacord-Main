local Package = {}

local Token = FS.readFileSync(RuntimeLocation .. "Token")

function Package.OnInitialize()
    local Logger = Import("nl.cubic-inc.logger.Main"):new()
    local Client = Import("ga.duacord.duacord.Main").Client:new()

    Logger:Info("Package loaded!")

    Client:on("Loaded", function()
        local Guild = Client:GetGuild("783625199702245436")
        local Channel = Guild:GetChannel("783731240138047529")
    
        ---p(
        ---    Channel:Send(
        ---        {
        ---            content = "Hello"
        ---        }
        ---    )
        ---)

    --for i, v in pairs(Client.User) do print(i, v) end
    end)

    Client:Run(Token, {Debug = true})

end

return Package