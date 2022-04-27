return {
    WEBSOCKET = {
        TEXT   = 1,
        BINARY = 2,
        CLOSE  = 8,
    },
    DISCORD = {
        DISPATCH = 0,
        HEARTBEAT = 1,
        IDENTIFY = 2,
        PRESENCE_UPDATE = 3,
        VOICE_STATE_UDPATE = 4,
        RESUME = 6,
        RECONNECT = 7,
        REQUEST_GUILD_MEMBERS = 8,
        INVALID_SESSION = 9,
        HELLO = 10,
        HEARTBEAT_ACK = 11
    }
}