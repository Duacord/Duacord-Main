local API = Class:extend()

local Request = require("coro-http").request
local Json = require("json")

local Constant = Import("ga.duacord.Client.API.Constant")

function API:initialize(Client)
    self.Client = Client
end

--#region Request Methods
local UserAgent = string.format("DiscordBot (%s, %s)", TypeWriter.LoadedPackages.duacord.Package.Contact.Source, TypeWriter.LoadedPackages.duacord.Package.Version)
local SuccessCodes = {
    [200] = true,
    [201] = true,
    [204] = true
}
function API:Request(Method, Endpoint, Data, Auth, Headers)
    p(Data)
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
    if SuccessCodes[Response.code] == nil then
        TypeWriter.Logger.Error(Response.code .. " - " .. Response.reason .. " - " .. Body .. " : " .. Endpoint)
        return
    end
    return Response, Body
end

function API:JsonRequest(Method, Endpoint, Data, Auth, Headers)
    local EncodedData
    if Data ~= nil then
        EncodedData = Json.encode(Data)
    end

    if Headers == nil then
        Headers = {}
    end
    Headers["Content-Type"] = "application/json"

    local Response, Body = self:Request(Method, Endpoint, EncodedData, Auth, Headers)
    local Decoded
    if Body then
        Decoded = Json.decode(Body)
    end
    return Response, Decoded
end

function API:DiscordRequest(Method, Endpoint, Data, Headers, Auth, ReturnResponse)
    if Auth == nil then
        Auth = true
    end

    local Response, Body = self:JsonRequest(Method, Constant.Discord.Https .. Endpoint, Data, Auth, Headers)
    if ReturnResponse == true then
        return Response, Body
    else
        return Body
    end
end

local function ToHex(Character)
    return string.format('%%%02X', byte(Character))
end

function API:UrlEncode(Object)
    return (string.gsub(tostring(Object), '%W', ToHex))
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

--#region Application commands
function API:BulkOverwriteGlobalApplicationCommands(Data)
    p(Data)
    self:DiscordRequest(
        "PUT",
        string.format(
            "/applications/%s/commands",
            "791927279357657088"--self.Client.User.Id
        ),
        Data
    )
end
--#endregion

--#region Objects
    --#region Channel Methods
        function API:ModifyChannel(ChannelId, Data)
            return self:DiscordRequest(
                "PATCH",
                string.format(
                    "/channels/%s",
                    Id
                ),
                Data
            )            
        end

        function API:DeleteChannel(ChannelId)
            return self:DiscordRequest(
                "DELETE",
                string.format(
                    "/channels/%s",
                    Id
                )
            )
        end

        function API:GetMessage(ChannelId, MessageId)
            return self:DiscordRequest(
                "GET",
                string.format(
                    "/channels/%s/messages/%s",
                    ChannelId,
                    MessageId
                )
            )
        end
        
        function API:CreateMessage(ChannelId, Data)
            return self:DiscordRequest(
                "POST",
                string.format(
                    "/channels/%s/messages",
                    ChannelId
                ),
                Data
            )
        end

        -- Crosspost message 

        function API:CreateReaction(ChannelId, MessageId, Emoji)
            return self:DiscordRequest(
                "PUT",
                string.format(
                    "/channels/%s/messages/%s/reactions/%s/@me",
                    ChannelId,
                    MessageId,
                    self:UrlEncode(Emoji)
                )
            )
        end

        function API:RemoveReaction(ChannelId, MessageId, Emoji, UserId)
            return self:DiscordRequest(
                "DELETE",
                string.format(
                    "/channels/%s/messages/%s/reactions/%s/%s",
                    ChannelId,
                    MessageId,
                    self:UrlEncode(Emoji),
                    UserId or "@me"
                )
            )
        end

        -- Get reactions

        function API:DeleteReactions(ChannelId, MessageId, Emoji)
            local EncodedEmoji
            if Emoji ~= nil then
                EncodedEmoji = "/" .. self:UrlEncode(Emoji)
            end
            return self:DiscordRequest(
                "DELETE",
                string.format(
                    "/channels/%s/messages/%s/reactions%s",
                    ChannelId,
                    MessageId,
                    EncodedEmoji
                )
            )
        end

        function API:EditMessage(ChannelId, MessageId, Data)
            return self:DiscordRequest(
                "PATCH",
                string.format(
                    "/channels/%s/messages/%s",
                    ChannelId,
                    MessageId
                ),
                Data
            )
        end

        function API:DeleteMessage(ChannelId, MessageId)
            return self:DiscordRequest(
                "DELETE",
                string.format(
                    "/channels/%s/messages/%s",
                    ChannelId,
                    MessageId
                )
            )
        end

        -- Bulk Delete Messages

        -- Edit Channel Permissions

        -- Get Channel Invites

        -- Create Channel Invite

        -- Delete Channel Permission

        -- Follow News Channel

        -- Trigger Typing Indicator

        -- Get Pinned Messages

        -- Pin Message

        -- Unpin Message

        -- Group DM Add Recipient

        -- Group DM Remove Recipient

        -- Start Thread from Message

        -- Start Thread without Message

        -- Start Thread in Forum Channel

        -- Join Thread

        -- Add Thread Member

        -- Leave Thread

        -- Remove Thread Member

        -- Get Thread Member

        -- List Thread Members

        -- List Active Threads

        -- List Public Archived Threads

        -- List Private Archived Threads

        -- List Joined Private Archived Threads



    --#endregion
--#endregion

return API