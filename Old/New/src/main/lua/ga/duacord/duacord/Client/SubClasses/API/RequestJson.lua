local Request = Import("ga.duacord.http.Main")["coro-http"].request

return function (Method, Url, Headers, Tbl, Tk, Client)

    Headers = Headers or {}

    if Tbl then
        local Body = Json.encode(Tbl)
        table.insert(Headers, {"content-length", #Body})
    end

    table.insert(Headers, {"content-type", "application/json"})
    if Tk ~= false then
        table.insert(Headers, {"Authorization", Client.Token})
    end

    table.insert(
        Headers,
        {
            "user-agent",
            string.format(
                "DiscordBot (%s, %s)",
                "https://github.com/Duacord/Duacord-Main",
                LoadedPackages["duacord-main"].PackageInfo.Version
            )
        }
    )


    local Response, Body = Request(Method, Url, Headers, Body)
    return Response, Json.decode(Body)
    
end