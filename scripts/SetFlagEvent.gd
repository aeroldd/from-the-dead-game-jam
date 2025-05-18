extends Event

# Event to set GameState flagss
class_name SetFlagEvent

@export var flags: Array[String]

func trigger():
	super.trigger()
	for flag in flags:
		GameState.set_flag(flag)
	SignalBus.emit_signal("event_finished")
