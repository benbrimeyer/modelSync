local tv = require(shared.modelSync.root.Parent.v.v)
local signals = require(script.Parent.signals)

return function(child)
	assert(tv.Instance(child))
	signals.childAdded:fire(child)
end