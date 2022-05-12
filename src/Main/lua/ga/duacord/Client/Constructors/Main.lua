local Constructors = {}


local function CreateConstructor(Client, Class)
    return function(Data)
        local Object = Class:new(Client, Data)
        return Object
    end
end
Constructors.CreateConstructor = CreateConstructor



Constructors.SlashCommands = {}
Constructors.SlashCommands.Command = Import("ga.duacord.Client.Constructors.SlashCommands.Command")
Constructors.SlashCommands.Option = Import("ga.duacord.Client.Constructors.SlashCommands.Option")


return Constructors