package = "kong-plugin-get-real-ip"
version = "0.1-1"
supported_platforms = {"linux", "macosx"}
source = {
  url = "https://github.com/better-maksim/kong-plugin-get-real-ip
  tag = "v0.1-1"
}
description = {
  summary = "获取真实 IP",
  license = "Apache 2.0",
  homepage = "https://github.com/better-maksim/kong-real-ip",
  detailed = [[
      获取真实 IP
  ]],
}
dependencies = {
  "lua ~> 5.1"
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.get_real_ip.handler"] = "src/handler.lua",
    ["kong.plugins.get_real_ip.schema"] = "src/schema.lua"
  }
}