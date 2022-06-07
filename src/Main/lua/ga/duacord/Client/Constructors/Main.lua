local Constructors = {}


local function CreateConstructor(Client, Class)
    return function(Data)
        local Object = Class:new(Client, Data)
        return Object
    end
end

Constructors.Components = {}
Constructors.Components.ActionRow = Import("ga.duacord.Client.Constructors.Components.ActionRow")
Constructors.Components.Button = Import("ga.duacord.Client.Constructors.Components.Button")
Constructors.Components.TextInput = Import("ga.duacord.Client.Constructors.Components.TextInput")

Constructors.Message = {}
Constructors.Message.Embed = Import("ga.duacord.Client.Constructors.Message.Embed")
Constructors.Message.Message = Import("ga.duacord.Client.Constructors.Message.Message")

Constructors.Modal = {}
Constructors.Modal.Modal = Import("ga.duacord.Client.Constructors.Modal.Modal")

Constructors.Commands = {}
Constructors.Commands.SlashCommand = Import("ga.duacord.Client.Constructors.Commands.SlashCommand")
Constructors.Commands.Option = Import("ga.duacord.Client.Constructors.Commands.SlashOption")
Constructors.Commands.UserCommand = Import("ga.duacord.Client.Constructors.Commands.UserCommand")

local function WrapConstructors(Tbl, Client)
    local ReturnData = {}
    for Index, Value in pairs(Tbl) do
        if type(Value) == "table" then
            if type(Value.new) == "function" then
                ReturnData[Index] = CreateConstructor(Client, Value)
            else
                ReturnData[Index] = WrapConstructors(Value, Client)
            end
        end
    end
    return ReturnData
end
return function (Client)
    return WrapConstructors(Constructors, Client)
end