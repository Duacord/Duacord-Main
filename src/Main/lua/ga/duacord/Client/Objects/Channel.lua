local Channel = Class:extend()

--#region Class methods
function Channel:initialize(Client, Parent, ParentType)
    self.Client = Client
    self[ParentType] = Parent
end

function Channel:BeforeInsert(Data)
end
--#endregion

function Channel:Send(Data)
    if type(Data) == "string" then
        Data = {
            Content = Data
        }
    end

    self.Client.API:CreateMessage(
        self.Id,
        {
            content = Data.Content,
            tts = Data.TTS,
            embeds = Data.Embeds,
            allowed_mentions = Data.AllowedMentions,
            message_reference = Data.MessageReference,
            components = Data.Components,
            sticker_ids = Data.StickerIds
        }
    )
end

return Channel