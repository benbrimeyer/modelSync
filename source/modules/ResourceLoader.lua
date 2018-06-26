local ResourceLoader = {}
ResourceLoader.__index = ResourceLoader

function ResourceLoader.new(package)
	local self = {
		isRunning = false,
		package = package,
	}
	setmetatable(self, ResourceLoader)

	return self
end

function ResourceLoader:Start()
	if self.isRunning then
		return
	end
	self.isRunning = true

	for _, object in pairs(script.Parent.resources:GetChildren()) do
		self.package[object.Name] = require(object)
	end
end

function ResourceLoader:Stop()
	if not self.isRunning then
		return
	end
	self.isRunning = false

	for _, object in pairs(script.Parent.resources:GetChildren()) do
		self.package[object.Name] = nil
	end
end

return ResourceLoader