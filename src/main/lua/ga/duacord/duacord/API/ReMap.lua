return function (Class, Data, DoPrint)

    local Client = Class.Client

    for Index, MapName in pairs(Class.ClassMap) do

        if DoPrint == true then
            p(Index)
            p(MapName)
            p(Data[MapName])
            p()
        end
        
        Class[Index] = Data[MapName] or Class[Index]
    end

    Client.Logger:Debug("Remapped " .. tostring(Class))

end