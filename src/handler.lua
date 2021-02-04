local BasePlugin = require "kong.plugins.base_plugin"
local handler = BasePlugin:extend()

local kong = kong
local ngx = ngx

handler.PRIORITY = 2000

function handler:new()
  handler.super.new(self, "getreal_ip")
end

function handler:getRealIp()
    local headers=ngx.req.get_headers()
    local client_ip = headers["x-forwarded-for"]

    if client_ip == nil or string.len(client_ip) == 0 or client_ip == "unknown" then
        client_ip = headers["Proxy-Client-IP"]
    end

    if client_ip == nil or string.len(client_ip) == 0 or client_ip == "unknown" then
        client_ip = headers["WL-Proxy-Client-IP"]
    end

    if client_ip == nil or string.len(client_ip) == 0 or client_ip == "unknown" then
        client_ip = ngx.var.remote_addr
    end

    if client_ip ~= nil and string.len(client_ip) >15  then
        local pos  = string.find(client_ip, ",", 1)
        client_ip = string.sub(client_ip,1,pos-1)
    end

    return client_ip;
end

function handler:access(conf)

  handler.super.access(self)
  local response = {}
  local data = {};
  response["message"] = "success"
  response["data"] = data;
  response["code"] = 200;
  data["reqeust_header"] = kong.request.get_headers()
  data["ip"] = self.getRealIp()

  return kong.response.exit(200, response , {
    ["Content-Type"] = "application/json",
    ["WWW-Authenticate"] = "Basic"
})

end

return handler