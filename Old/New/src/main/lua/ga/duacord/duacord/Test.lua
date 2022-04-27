local Package = {}

function Package.OnInitialize()

    local Client = Import("ga.duacord.duacord.Main").Client:new({Debug = true})
    local Token = FS.readFileSync("../Token")

    Client:Run(Token)

end

return Package
