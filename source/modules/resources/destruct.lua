local tv = require(shared.modelSync.root.Parent.v.v)
local signals = require(script.Parent.signals)

return function(childName)
	assert(tv.string(childName))
	signals.childRemoved:fire(childName)
end