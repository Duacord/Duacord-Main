local Member = Class:extend()

function Member:initialize(Client, Guild)
    self.Client = Client
    self.Guild = Guild
end

function Member:OnInsert()
    
end

return Member