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

    local Role = Guild:GetRole("910169441168420884")
    
    Role:Edit()
  end)

  Client:on("Ready", function() Logger:Info("Ready event") end)

  Client:Run(Token)

  

end

return Package
