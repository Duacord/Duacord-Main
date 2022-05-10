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

--#region
Gateway.CloseCodes = {}
Gateway.CloseCodes[4000] = {
    Error = "Unknown error",
    Reason = "We're not sure what went wrong. Try reconnecting?",
    CanReconnect = true
}	
Gateway.CloseCodes[4001] = {
    Error = "Unknown opcode",
    Reason = "You sent an invalid Gateway opcode or an invalid payload for an opcode. Don't do that!",
    CanReconnect = true
}	
Gateway.CloseCodes[4002] = {
    Error = "Decode error",
    Reason = "You sent an invalid payload to us. Don't do that!",
    CanReconnect = true
}	
Gateway.CloseCodes[4003] = {
    Error = "Not authenticated",
    Reason = "You sent us a payload prior to identifying.",
    CanReconnect = true
}	
Gateway.CloseCodes[4004] = {
    Error = "Authentication failed",
    Reason = "The account token sent with your identify payload is incorrect.",
    CanReconnect = false
}	
Gateway.CloseCodes[4005] = {
    Error = "Already authenticated",
    Reason = "You sent more than one identify payload. Don't do that!",
    CanReconnect = true
}	
Gateway.CloseCodes[4007] = {
    Error = "Invalid seq",
    Reason = "The sequence sent when resuming the session was invalid. Reconnect and start a new session.",
    CanReconnect = true
}	
Gateway.CloseCodes[4008] = {
    Error = "Rate limited",
    Reason = "Woah nelly! You're sending payloads to us too quickly. Slow it down! You will be disconnected on receiving this.",
    CanReconnect = true
}	
Gateway.CloseCodes[4009] = {
    Error = "Session timed out",
    Reason = "Your session timed out. Reconnect and start a new one.",
    CanReconnect = true
}	
Gateway.CloseCodes[4010] = {
    Error = "Invalid shard",
    Reason = "You sent us an invalid shard when identifying.",
    CanReconnect = false
}	
Gateway.CloseCodes[4011] = {
    Error = "Sharding required",
    Reason = "The session would have handled too many guilds - you are required to shard your connection in order to connect.",
    CanReconnect = false
}	
Gateway.CloseCodes[4012] = {
    Error = "Invalid API version",
    Reason = "You sent an invalid version for the gateway.",
    CanReconnect = false
}	
Gateway.CloseCodes[4013] = {
    Error = "Invalid intent(s)",
    Reason = "You sent an invalid intent for a Gateway Intent . You may have incorrectly calculated the bitwise value.",
    CanReconnect = false
}	
Gateway.CloseCodes[4014] = {
    Error = "Disallowed intent(s)",
    Reason = "You sent a disallowed intent for a Gateway Intent . You may have tried to specify an intent that you have not enabled or are not approved for.",
    CanReconnect = false
}
--#endregion


return Gateway