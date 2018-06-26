local PluginService = plugin
local root = script.Parent

shared.modelSync = {}
shared.modelSync.root = root
_G.modelSync = shared.modelSync
shared.require = require(script.Parent.require)(root)

local require = shared.require

local PluginMaster = require("PluginMaster")

local pluginMaster = PluginMaster.new(PluginService, shared.modelSync)
pluginMaster:Start()

shared.modelSync.signals.activated:connect(function(isActive)
end)

shared.modelSync.signals.childAdded:connect(function(child)
end)

shared.modelSync.signals.childRemoved:connect(function(childName)
end)