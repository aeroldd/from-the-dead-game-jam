extends Event

class_name InstantiateSceneEvent

@export var dialogue: Resource

func trigger():
	super.trigger()
	SignalBus.emit_signal("instantiate_scene", dialogue)
	
