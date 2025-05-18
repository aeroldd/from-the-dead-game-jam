extends Resource

# This event will only run if the certain flags are set
class_name ConditionalEvent

@export var conditions: Array[String] = []
@export var event: Event
