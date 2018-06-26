local require = shared.require

local tv = require("v")

local CollectionService = game:GetService("CollectionService")

local function render(sourceModel)
	local tagName = sourceModel.Name
	for _, oldObject in pairs(CollectionService:GetTagged(tagName)) do
		local previousCFrame = oldObject.PrimaryPart.CFrame
		oldObject:ClearAllChildren()

		local temporaryModel = sourceModel:Clone()
		local primaryPart = temporaryModel.PrimaryPart
		for _, child in pairs(temporaryModel:GetChildren()) do
			child.Parent = oldObject
		end
		oldObject.PrimaryPart = primaryPart
		oldObject:SetPrimaryPartCFrame(previousCFrame)
		temporaryModel:Destroy()
	end
end

return function(optionalTags)
	local map = {}
	if optionalTags then
		for _, tag in pairs(optionalTags) do
			map[tag] = true
		end
	end

	for _, sourceModel in pairs(shared.modelSync.magicFolder:GetChildren()) do
		if map[sourceModel.Name] or not optionalTags then
			render(sourceModel)
		end
	end
end