
return function (Client)
    local Constants = Client.Constants

    local Response, Data = Client.API:RequestJson(
        "GET",
        Constants.API.API_URL .. Constants.EndPoints.GATEWAY_BOT,
        {}
    )

    return Data
end