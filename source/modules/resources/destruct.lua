local signals = require(script.Parent.signals)

return function(childName)
	signals.childRemoved:fire(childName)
end