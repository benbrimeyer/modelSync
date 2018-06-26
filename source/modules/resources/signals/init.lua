local Signal = require(script.Signal)

return {
	activated = Signal.new(),
	childAdded = Signal.new(),
	childRemoved = Signal.new(),
}