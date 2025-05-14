extends Event

class_name DialogueEvent
@export var dialogue: Dialogue

func trigger():
	super.trigger()
	SignalBus.emit_signal("show_dialogue", dialogue)
	
