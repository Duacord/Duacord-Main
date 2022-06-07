local Embed = Object:extend()

function Embed:initialize(Client, Data)
    Data = Data or {}
    self.Client = Client

    self.Data = Data
    self.Data.fields = Data.fields or {}
end

function Embed:SetTitle(Title)
    self.Data.title = Title
    return self
end

function Embed:SetDescription(Description)
    self.Data.description = Description
    return self
end

function Embed:SetUrl(Url)
    set.Data.url = Url
    return self
end

function Embed:SetTimestamp(Timestamp)
    self.Data.timestamp = Timestamp
    return self
end

function Embed:SetColor(Color)
    self.Data.color = Color
    return self
end

function Embed:SetFooter(Body, Url)
    self.Data.footer = {text = Body, icon_url = Url}
    return self
end

function Embed:SetImage(Url)
    self.Data.image = {url = Url}
    return self
end

function Embed:SetThumbnail(Url)
    self.Data.thumbnail = {url = Url}
    return self
end

function Embed:SetAuthor(Name, Url)
    self.Data.author = {name = Name, url = Url}
    return self
end

function Embed:AddField(Title, Value, Inline)
    table.insert(
        self.Data.fields,
        {
            name = Title,
            value = Value,
            inline = Inline
        }
    )
    return self
end

function Embed:Export()
    return self.Data
end

return Embed