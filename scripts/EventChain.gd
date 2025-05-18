extends Event

class_name EventChain

@export var events: Array[Event]

var current_event = 0

func _ready():
	SignalBus.connect("event_finished", next_event)

func trigger():
	if current_event < events.size():
		events[current_event].trigger()
	
func next_event():
	current_event += 1
	if current_event < events.size():
		trigger()
