extends Node

var current_event

func _ready():
	SignalBus.connect("trigger_event", run_event)	
	process_mode = PROCESS_MODE_ALWAYS
	
func run_event(event: Event):
	current_event = get_conditional_event(event)
	event.trigger()

# Returns the correct event based on the conditions - all flags need to be true
func get_conditional_event(event: Event) -> Event:	
	# Iterate through each conditional event
	for conditionals in event.conditionals:
		var all_flags_true = true
		for condition in conditionals.conditions:
			if GameState.has_flag(condition):
				continue
				
			# If the Game doesnt have the flag, all the flags aren't true
			all_flags_true = false
			
		# Return the first true conditional event
		if all_flags_true:
			return conditionals.event
				
	return event
