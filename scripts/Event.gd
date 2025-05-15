extends Node

class_name Event

var event_name: String
var event_id: int

func _ready():
	SignalBus.connect("trigger_event", trigger)

# Will be overloaded by dialogue etc
func trigger():
	get_tree().paused = true
	print("Game paused - event is triggered")
