local Guild = Class:extend()

local Member = Import("ga.duacord.Client.Objects.Member")


function Guild:initialize(Client)
    self.Client = Client
end

function Guild:BeforeInsert(Data)
    p(Data)
end

function Guild:OnInsert()
    local Members = self.Members
    self.Members = {}
    for Index, Value in pairs(Members) do
        local Member = Member:new(self.Client, self)
    end
end

return Guild