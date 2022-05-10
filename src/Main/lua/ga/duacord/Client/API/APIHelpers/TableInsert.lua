return function (Original, ToInsert)

    if type(Original.BeforeInsert) == "function" then
        Original:BeforeInsert(ToInsert)
    end

    for Index, Value in pairs(ToInsert) do
        Original[Index] = Value
    end

    if type(Original.OnInsert) == "function" then
        Original:OnInsert(ToInsert)
    end
    
    return Original
end