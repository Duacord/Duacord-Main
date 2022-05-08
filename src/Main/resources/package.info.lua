-- See https://github.com/Dot-lua/TypeWriter/wiki/package.info.lua-format for more info

return { InfoVersion = 1, -- Dont touch this

    ID = "duacord", -- A unique id 
    Name = "DuaCord",
    Description = "A discord library for Lua",
    Version = "1.0.0",

    Author = {
        Developers = {
            "CoreByte"
        },
        Contributors = {}
    },

    Dependencies = {
        Luvit = {
            "creationix/coro-http",
            "creationix/coro-websocket",
            "luvit/secure-socket",
        },
        Git = {},
        Dua = {}
    },

    Contact = {
        Website = "https://duacord.ga",
        Source = "https://github.com/duacord/",
        Socials = {}
    },

    Entrypoints = {
        Main = "ga.duacord.Test"
    }
}
