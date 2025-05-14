extends Node

func _ready():
	SignalBus.connect("trigger_event", run_event)	
	process_mode = PROCESS_MODE_ALWAYS
	
func run_event(event: Event):
	event.trigger()
