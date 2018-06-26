local CollectionService = game:GetService("CollectionService")

local constants = require(script.Parent.constants)
local signals = require(script.Parent.signals)



local function setMagicFolder(folder)
	if folder:IsA("Folder") then
		shared.modelSync.magicFolder = folder
		print(string.format("modelSync init - sourceFolder found.\nUsing %s", folder:GetFullName()))

		folder.AncestryChanged:Connect(function(_, newParent)
			if not newParent then
				warn("modelSync sourceFolder missing. Disabling")
				shared.modelSync.magicFolder = nil
				signals.activated:fire(false)
			end
		end)

		local function count(name)
			local count = 0
			for _, v in pairs(folder:GetChildren()) do
				if v.ClassName == "Model" and v.Name == name then
					count = count + 1
				end
			end
			return count
		end

		local function addChild(child)
			signals.childAdded:fire(child)
		end

		local function removeChild(childName)
			if count(childName) == 0 then
				signals.childRemoved:fire(childName)
			end
		end

		folder.ChildAdded:Connect(function(newChild)
			if newChild.ClassName ~= "Model" then
				return
			end

			local childName = newChild.Name
			if count(childName) > 1 then
				spawn(function()
					newChild.Parent = nil
					newChild.Name = childName .. "(duplicated)"
					newChild.Parent = folder
				end)
				return
			end

			addChild(newChild)

			newChild:GetPropertyChangedSignal("Name"):Connect(function()
				removeChild(childName)
				addChild(newChild)
				childName = newChild.Name
			end)
		end)

		folder.ChildRemoved:Connect(function(oldChild)
			if oldChild.ClassName ~= "Model" then
				return
			end
			removeChild(oldChild.Name)
		end)

		signals.activated:fire(true)
	end
end

return function()
	if shared.modelSync.magicFolder then
		warn("modelSync init is already running!")
		return
	end

	local tagged = CollectionService:GetTagged(constants.MAGIC_FOLDER_TAG)
	if #tagged == 0 then
		-- create new
		local selection = game.Selection:Get()[1]
		local folder = Instance.new("Folder")
		folder.Name = "sources-(modelSync)"
		folder.Parent = selection and selection.Parent or workspace
		setMagicFolder(folder)
	elseif #tagged > 1 then
		-- warn
		warn("modelSync init - Multiple sourceFolders found. Delete some!")
		game.Selection:Set(tagged)
		repeat wait() until #CollectionService:GetTagged(constants.MAGIC_FOLDER_TAG) <= 1
		local tagged = CollectionService:GetTagged(constants.MAGIC_FOLDER_TAG)
		if #tagged == 1 then
			setMagicFolder(tagged[1])
		end
	else
		setMagicFolder(tagged[1])
	end
end