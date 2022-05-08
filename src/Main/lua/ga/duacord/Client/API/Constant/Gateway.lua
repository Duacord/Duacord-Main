local Gateway = {}

Gateway.Get = "/gateway"
Gateway.GetBot = "/gateway/bot"

Gateway.Opcodes = {}
Gateway.Opcodes.Dispatch = 0
Gateway.Opcodes.Heartbeat = 1
Gateway.Opcodes.Identify = 2
Gateway.Opcodes.PresenceUpdate = 3
Gateway.Opcodes.VoiceStateUpdate = 4
Gateway.Opcodes.Resume = 6
Gateway.Opcodes.Reconnect = 7
Gateway.Opcodes.RequestGuildMembers = 8
Gateway.Opcodes.InvalidSession = 9
Gateway.Opcodes.Hello = 10
Gateway.Opcodes.HeartbeatAck = 11




return Gateway