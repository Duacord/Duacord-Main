local Package = {}

local Logger = Import("nl.cubic-inc.logger.Main")
local Client = Import("ga.duacord.duacord.Main").Client
local Token = FS.readFileSync(RuntimeLocation .. "Token")

function Package.OnInitialize()
  Logger:new()
  Client:new()

  Logger:Info("Package loaded!")

  Client:on("Ready", function()
    local Guild = Client:GetGuild("783625199702245436")

    local Role = Guild:GetRole("797073333186461698")
    
    p(Role:SetName("bla bla"))
  end)

  Client:on("Ready", function() Logger:Info("Ready event") end)

  Client:Run(Token)

  

end

return Package
