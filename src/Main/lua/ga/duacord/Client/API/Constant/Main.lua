local Constant = {}

Constant.ApplicationCommands         = Import("ga.duacord.Client.API.Constant.ApplicationCommands")
Constant.Cdn                         = Import("ga.duacord.Client.API.Constant.Cdn")
Constant.Discord                     = Import("ga.duacord.Client.API.Constant.Discord")
Constant.Gateway                     = Import("ga.duacord.Client.API.Constant.Gateway")
Constant.MessageComponents           = Import("ga.duacord.Client.API.Constant.MessageComponents")
Constant.Websocket                   = Import("ga.duacord.Client.API.Constant.Websocket")

Constant.Objects = {}
Constant.Objects.Guild               = Import("ga.duacord.Client.API.Constant.Objects.Guild")
Constant.Objects.Channel             = Import("ga.duacord.Client.API.Constant.Objects.Channel")

return Constant