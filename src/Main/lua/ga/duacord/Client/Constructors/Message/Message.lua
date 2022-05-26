local Message = Object:extend()

local Constant = Import("ga.duacord.Client.API.Constant")

function Message:initialize(Client, Data)
    Data = Data or {}
    self.Client = Client

    self.Data = Data
    self.Data.embeds = Data.embeds or {}
    self.Data.components = Data.components or {}
    self.Data.stickers = Data.stickers or {}
end

function Message:SetContent(Content)
    self.Data.content = Content
    return self
end

function Message:EnableTts(Bool)
    self.Data.tts = Bool
    return self
end

function Message:AddEmbed(Embed)
    if type(Embed.Export) == "function" then
        Embed = Embed:Export()
    end
    table.insert(self.Data.embeds, Embed)
    return self
end

--allowed_mentions
--message_reference

function Message:AddComponent(Component, Row)
    if Row == nil then
        Row = 1
    end
    if self.Data.components[Row] == nil then
        self.Data.components[Row] = self.Client.Constructors.Components.ActionRow()
    end
    self.Data.components[Row]:AddComponent(Component)
    return self
end

function Message:AddSticker(Id)
    table.insert(self.Data.stickers, Id)
    return self
end

function Message:SuppressEmbeds(Trigger)
    if Trigger == nil then
        Trigger = true
    end
    if Trigger then
        self.Data.flags = 0x00000004
    else
        self.Data.flags = nil
    end
    return self
end

function Message:Export()
    for Index, Row in pairs(self.Data.components) do
        self.Data.components[Index] = Row:Export()
    end
    return self.Data
end

return Message