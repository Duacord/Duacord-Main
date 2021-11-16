local Package = {}

local Logger = Import("nl.cubic-inc.logger.Main")
local Client = Import("ga.duacord.duacord.Main").Client
local Token = FS.readFileSync(RuntimeLocation .. "Token")

function Package.OnInitialize()
  Logger:new()
  Client:new()

  Logger:Info("Package loaded!")
  Client:on("READY", function() Logger:Info("Ready") end)
  Client:Run(Token)

end

return Package
