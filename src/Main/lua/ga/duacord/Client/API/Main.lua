local API = Class:extend()

local Request = require("coro-http").request
local Json = require("json")

local Constant = Import("ga.duacord.Client.API.Constant")

function API:initialize(Client)
    self.Client = Client
end

--#region Request Methods
local UserAgent = string.format("DiscordBot (%s, %s)", TypeWriter.LoadedPackages.duacord.Package.Contact.Source, TypeWriter.LoadedPackages.duacord.Package.Version)
function API:Request(Method, Endpoint, Data, Auth, Headers)
    if Headers == nil then
        Headers = {}
    end
    if Auth == nil then
        Auth = false
    end

    if Auth == true then
        Headers["Authorization"] = self.Client.Token
    end
    Headers["X-RateLimit-Precision"] = "millisecond"
    Headers["User-Agent"] = UserAgent

    local ParsedHeaders = {}
    for Index, Value in pairs(Headers) do
        table.insert(
            ParsedHeaders,
            {
                Index, Value
            }
        )
    end
    local Response, Body = Request(Method, Endpoint, ParsedHeaders, Data)
    return Response, Body
end

function API:JsonRequest(Method, Endpoint, Data, Auth, Headers)
    local EncodedData
    if Data ~= nil then
        EncodedData = Json.encode(Data)
    end

    local Response, Body = self:Request(Method, Endpoint, EncodedData, Auth, Headers)
    local Decoded
    if Body then
        Decoded = Json.decode(Body)
    end
    return Response, Decoded
end

function API:DiscordRequest(Method, Endpoint, Data, Headers, Auth)
    if Auth == nil then
        Auth = true
    end

    local Response, Body = self:JsonRequest(Method, Constant.Discord.Https .. Endpoint, Data, Auth, Headers)
    return Response, Body
end
--#endregion

--#region Gateway Methods
local GetGateway = Import("ga.duacord.Client.API.APIHelpers.GetGateway")

function API:GetGateway()
    return GetGateway.Get(self)
end

function API:GetGatewayBot()
    return GetGateway.GetBot(self)
end
--#endregion

--#region Table patcher

local TablePatcher = Import("ga.duacord.Client.API.APIHelpers.TablePatcher")
function API:PatchTable(Tbl)
    return TablePatcher(Tbl)
end

local TableInsert = Import("ga.duacord.Client.API.APIHelpers.TableInsert")
function API:InsertTable(Original, ToInsert)
    return TableInsert(Original, ToInsert)
end

--#endregion

return API