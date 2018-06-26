local signals = require(script.Parent.signals)

return function(child)
	signals.childAdded:fire(child)
end