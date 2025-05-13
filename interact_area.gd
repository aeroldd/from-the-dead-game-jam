extends Node2D

@onready var area = $Area2D
var area_active = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	area_active = true
	
func _on_area_2d_area_exited(area: Area2D) -> void:
	area_active = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and area_active:
		SignalBus.emit_signal("interact")
		
		print("Interacted with me!!")
