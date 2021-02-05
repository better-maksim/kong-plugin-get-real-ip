# Kong网关获取真实 IP

Kong 网关在多层负载情况时，`kong.request.get_forwarded_ip()` 无法获取真实客户端 IP。

需要从 header 中拿出 `x-forwarded-for`。

```lua

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

```