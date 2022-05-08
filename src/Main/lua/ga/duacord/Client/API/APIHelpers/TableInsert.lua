return function (Original, ToInsert)
    for Index, Value in pairs(ToInsert) do
        Original[Index] = Value
    end

    if type(Original.OnInsert) == "function" then
        Original:OnInsert(ToInsert)
    end
    
    return Original
end