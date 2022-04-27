local API = Class:extend()

function API:initialize(Client)
    self.Client = Client
end

function API:RequestJson(Method, Url, Headers, Body, Tk)
    return Import("ga.duacord.duacord.Client.SubClasses.API.RequestJson")(Method, Url, Headers, Body, Tk, self.Client)
end

function API:GatewayBot()
    return Import("ga.duacord.duacord.Client.SubClasses.API.GatewayBot")(self.Client)
end

function API:RemapClass(Class, Data, DoPrint)
    return Import("ga.duacord.duacord.Client.SubClasses.API.ReMap")(Class, Data, DoPrint)
end

return API