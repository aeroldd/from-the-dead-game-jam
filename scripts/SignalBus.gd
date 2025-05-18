extends Node

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	
signal interact()

# This signal triggers the event passed as a parameter
signal trigger_event(event: Event)

signal show_dialogue(dialogue: Dialogue)
signal dialogue_finished(dialogue: Dialogue)

signal event_finished()
