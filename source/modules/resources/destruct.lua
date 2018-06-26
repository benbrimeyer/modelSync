local tv = require(shared.modelSync.root.Parent.tv.t)
local signals = require(script.Parent.signals)

return function(childName)
	assert(tv.string(childName))
	signals.childRemoved:fire(childName)
end