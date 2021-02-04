package = "kong-plugin-get-real-ip"
version = "0.1-1"
supported_platforms = {"linux", "macosx"}
source = {
  url = "https://github.com/better-maksim/kong-plugin-get-real-ip",
  tag = "v0.1-1"
}
description = {
  summary = "获取真实 IP",
  license = "Apache 2.0",
  homepage = "https://github.com/better-maksim/kong-plugin-get-real-ip",
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
    ["kong.plugins.get-real-ip.handler"] = "kong/plugins/get-real-ip/handler.lua",
    ["kong.plugins.get-real-ip.schema"] = "kong/plugins/get-real-ip/schema.lua"
  }
}