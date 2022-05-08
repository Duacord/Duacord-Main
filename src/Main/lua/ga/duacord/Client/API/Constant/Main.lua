local Constant = {}

Constant.Cdn                         = Import("ga.duacord.Client.API.Constant.Cdn")
Constant.Discord                     = Import("ga.duacord.Client.API.Constant.Discord")
Constant.Gateway                     = Import("ga.duacord.Client.API.Constant.Gateway")
Constant.Websocket                   = Import("ga.duacord.Client.API.Constant.Websocket")

Constant.Objects = {}
Constant.Objects.Guild               = Import("ga.duacord.Client.API.Constant.Objects.Guild")

return Constant