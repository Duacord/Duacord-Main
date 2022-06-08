local Interaction = Class:extend()

local ApplicationCommandConstant = Import("ga.duacord.Client.API.Constant").ApplicationCommands
local Bit = require("bit")

function Interaction:initialize(Client)
    self.Client = Client
end

function Interaction.meta:__tostring()
    return "Interaction: " .. self.Id
end

function Interaction:BeforeInsert(Data)
    if Data.GuildId ~= nil then
        self.Guild = self.Client:GetGuild(Data.GuildId)
        Data.GuildId = nil

        self.Channel = self.Guild:GetChannel(Data.ChannelId)
        Data.ChannelId = nil

        self.Member = self.Guild:GetMember(Data.Member.id)
        Data.Member = nil
    end
    Data.Version = nil

    self.HookUrl = string.format("/interactions/%s/%s", Data.Id, Data.Token)
end

function Interaction:Request(Method, Endpoint, Data)
    return self.Client.API:DiscordRequest(Method, self.HookUrl .. Endpoint, Data)
end

function Interaction:CreateResponse(Type, Data)
    return self:Request("POST", "/callback", {type = Type, data = Data})
end

function Interaction:Autocomplete(Choices)
    return self:CreateResponse(ApplicationCommandConstant.ApplicationCommandAutocompleteResult, Choices)
end

function Interaction:DeleteReply(Id)
    if Id == nil then
        Id = "@original"
    end

    return self:Request("DELETE", "/messages/" .. Id)
end

function Interaction:EditReply(Content, Id)
    if Id == nil then
        Id = "@original"
    end
    if type(Content) == "string" then
        Content = {content = Content}
    end
    return self:Request("PATCH", "/messages/" .. Id, Content)
end

function Interaction:GetReply(Id)
    if Id == nil then
        Id = "@original"
    end

    return self:Request("GET", "/messages/" .. Id)
end

function Interaction:Reply(Message, Ephemeral)
    if type(Message) == "string" then
        Message = {content = Message}
    end
    if Ephemeral then 
        Message.flags = Bit.bor(type(Message.flags) == "number" or 0, 0x00000040)
    end
    self:CreateResponse(ApplicationCommandConstant.Responses.ChannelMessageWithSource, Message)
end

function Interaction:ReplyDeferred(Ephemeral)
    return self:CreateResponse(ApplicationCommandConstant.Responses.DeferredChannelMessageWithSource, {ephemeral = Ephemeral})
end

function Interaction:Update(Message)
    if type(Message) == "string" then
        Message = {content = Message}
    end
    return self:CreateResponse(ApplicationCommandConstant.Responses.UpdateMessage, Message)
end

function Interaction:UpdateDeferred()
    return self:CreateResponse(ApplicationCommandConstant.Responses.DeferredUpdateMessage)
end

function Interaction:ShowModal(Modal)
    if type(Modal.Export) == "function" then
        Modal = Modal:Export()
    end
    return self:CreateResponse(ApplicationCommandConstant.Responses.Modal, Modal)
end

return Interaction