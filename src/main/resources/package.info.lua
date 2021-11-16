return {

    InfoVersion = 1, -- Dont touch this

    ID = "DuaCord-Main", -- A unique id 
    Version = "0.0.1", -- The package version

    Name = "DuaCord-Main", -- The name of the project, can use spaces
    Description = "The Main DuaCord Package", -- Description

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
        Website = "http://cubic-inc.nl", -- Homepage
        Source = "https://github.com/Dot-lua/Dotter-Project-Template", -- Github repro
        Socials = {}
    },

    Icon = "",
    Environment = "*",
    Entrypoints = {
        Main = "ga.duacord.duacord.Test",
        OnLoad = "ga.duacord.duacord.OnLoad"
    }

}
