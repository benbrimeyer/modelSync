local tv = require(shared.modelSync.root.Parent.tv.t)

return function(root)
	assert(tv.Instance(root))
	local cache = {}
	for _, object in pairs(root:GetDescendants()) do
		if object:IsA("ModuleScript") then
			if cache[object.Name] then
				warn(string.format("Duplicate entries found for: %s", object.Name))
			end

			cache[object.Name] = object
		end
	end

	return function(name)
		assert(tv.string(name))
		return require(cache[name])
	end
end