local GetGateway = {}

local Constant = Import("ga.duacord.Client.API.Constant")

function GetGateway.Get(API)
    local _, Data = API:DiscordRequest("GET", Constant.Gateway.Get, nil, nil, false)

    return {
        Url = Data.url,
    }
end

function GetGateway.GetBot(API)
    local _, Data = API:DiscordRequest("GET", Constant.Gateway.GetBot)

    return {
        Url = Data.url,
        SessionStartLimit = {
            Total = Data.session_start_limit.total,
            MaxConcurrency = Data.session_start_limit.max_concurrency,
            Remaining = Data.session_start_limit.remaining,
            ResetAfter = Data.session_start_limit.reset_after
        },
        Shards = Data.shards,
    }
end

return GetGateway