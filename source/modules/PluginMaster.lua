local require = shared.require

local ResourceLoader = require("ResourceLoader")

local TOOLBAR_NAME = "test"

local PluginMaster = {}
PluginMaster.__index = PluginMaster

function PluginMaster.new(plugin, package)
	local self = {
		plugin = plugin,
		package = package,
		toolbar = nil,
	}
	setmetatable(self, PluginMaster)

	self.resourceLoader = ResourceLoader.new(package)

	return self
end

function PluginMaster:Start()
	if self.isRunning then
		return
	end
	self.isRunning = true

	self.toolbar = self.plugin:CreateToolbar(TOOLBAR_NAME)
	self.resourceLoader:Start()
end

function PluginMaster:Stop()
	if not self.isRunning then
		return
	end
	self.isRunning = false

end

return PluginMaster