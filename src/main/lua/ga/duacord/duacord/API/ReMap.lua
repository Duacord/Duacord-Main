return function (Class, Data)

    local Client = Class.Client

    for Index, MapName in pairs(Class.ClassMap) do


        Class[Index] = Data[MapName] or Class[Index]
    end

    Client.Logger:Debug("Remapped " .. tostring(Class))

end