local Websocket = {}

Websocket.Opcodes = {}
Websocket.Opcodes.CONTINUATION = 0
Websocket.Opcodes.TEXT = 1
Websocket.Opcodes.BINARY = 2
Websocket.Opcodes.CLOSE = 8
Websocket.Opcodes.PING = 9
Websocket.Opcodes.PONG = 10


return Websocket