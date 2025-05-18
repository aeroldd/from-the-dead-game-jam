extends Resource

class_name Event

var event_name: String
var event_id: int

@export var conditionals: Array[ConditionalEvent]

func _ready():
	SignalBus.connect("trigger_event", trigger)

# Will be overloaded by dialogue etc
func trigger():
	print("Event triggered.")
