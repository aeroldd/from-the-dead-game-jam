extends Resource

class_name Option

@export var option_name: String
@export var dialogue: Dialogue # The dialogue that will play after selecting this option. Set to null if there is no more dialogue after it

@export var conditions: Array[String] # Flags which are needed for this flag to be active
@export var set_flags: Array[String] # Flags that will be set after running the dialogue
