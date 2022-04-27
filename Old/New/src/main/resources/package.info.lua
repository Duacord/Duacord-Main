return {

    InfoVersion = 1, -- Dont touch this

    ID = "duacord-main", -- A unique id 
    Version = "1.0.0", -- The package version

    Name = "Duacord Main", -- The name of the project, can use spaces
    Description = "Main Duacord Package", -- Description

    Author = {
        Developers = {
            "CoreByte"
        },
        Contributors = {}
    },

    Dependencies = {
        Luvit = {},
        Dua = {}
    },

    Contact = {
        Website = "http://duacord.ga", -- Homepage
        Source = "https://github.com/duacord", -- Github repro
        Socials = {}
    },

    Entrypoints = {
        Main = "ga.duacord.duacord.Test",
        OnLoad = "ga.duacord.duacord.Load"
        -- CubyPackage = "some.other.entry.caused.by.another.package", -- a package can call another packages entrypoints
    }

}
