extends Event

class_name DialogueEvent
@export var dialogue: Resource

func trigger():
	super.trigger()
	SignalBus.emit_signal("show_dialogue", dialogue)
	
