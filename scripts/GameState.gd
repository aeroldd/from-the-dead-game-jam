extends Node

var dialogue_active = false

# In game flags which affect the game

var flags = {}

func set_flag(flag_name: String, value: bool = true):
	flags[flag_name] = value
	
func has_flag(flag_name: String) -> bool:
	return flags.get(flag_name, false)
