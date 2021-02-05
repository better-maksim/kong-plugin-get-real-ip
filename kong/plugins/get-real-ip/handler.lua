local BasePlugin = require "kong.plugins.base_plugin"

local GetRealIpHandler = BasePlugin:extend()

local ngx = ngx
local kong = kong



GetRealIpHandler.PRIORITY = 1000

function GetRealIpHandler:new()
  GetRealIpHandler.super.new(self, "get-real-ip")
end

function GetRealIpHandler:getRealIp()
   --越过kong 网关的配置，直接走 x-forwarded-for
   local client_ip = kong.request.get_header("x-forwarded-for");

   -- 如果 x-forwarded-for 等于空，则按照 kong 网关的形式去取值
   if client_ip == nil or string.len(client_ip) == 0 or client_ip == "unknown" then
       client_ip = kong.request.get_forwarded_ip();
   end

   -- 需要考虑 x-forwarded-for 的网关转发
   if client_ip ~= nil and string.len(client_ip) > 15 then
       local pos = string.find(client_ip, ",", 1)
       client_ip = string.sub(client_ip, 1, pos - 1)
   end
   return client_ip;
end

function GetRealIpHandler:access(conf)

  GetRealIpHandler.super.access(self)

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

return GetRealIpHandler