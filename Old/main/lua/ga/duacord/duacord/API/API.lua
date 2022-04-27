local API = Class:extend()

local Request = Import("ga.duacord.duacord.API.Request")


function API:initialize(Client)
    self.Client = Client
end

function API:Request(Method, Url, Body, AuditReason)
    return Request(Method, Url, Body, AuditReason, self.Client)
end


return API