local tv = require(shared.modelSync.root.Parent.tv.t)

local CollectionService = game:GetService("CollectionService")

local function render(datamodelRoot, sourceModel)
	local tagName = sourceModel.Name
	for _, oldObject in pairs(CollectionService:GetTagged(tagName)) do
		if not oldObject:IsDescendantOf(datamodelRoot) then
			return
		end

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

local check = tv.tuple(tv.optional(tv.Instance), tv.optional(tv.strictArray(tv.string)))
return function(datamodelRoot, optionalTags)
	assert(check(datamodelRoot, optionalTags))
	datamodelRoot = datamodelRoot or workspace

	local map = {}
	if optionalTags then
		for _, tag in pairs(optionalTags) do
			map[tag] = true
		end
	end

	for _, sourceModel in pairs(shared.modelSync.magicFolder:GetChildren()) do
		if map[sourceModel.Name] or not optionalTags then
			render(datamodelRoot, sourceModel)
		end
	end
end