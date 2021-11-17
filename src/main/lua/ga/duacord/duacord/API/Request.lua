local Http = Import("ga.duacord.http.Main")

return function(Method, Url, Body, AuditReason, Client)

    local Response, Body = Http["coro-http"].request(
        Method,
        Url,
        {
            Client.AuthHeader,
            {"X-Audit-Log-Reason", AuditReason},
            {"User-Agent", "Duacord Library"},
            {"Content-Type", "application/json"}
        },
        Json.encode(Body)
    )

    return Response, Json.decode(Body)

end