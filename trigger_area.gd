extends Area2D

@export var single_trigger: bool = true
@export var interact_trigger: bool = false
var triggered = false

var player_inside_trigger = false

@onready var state_label = $StateLabel
@onready var other_lab = $Triggered

@export var event: Event


func _on_body_entered(body: Node2D) -> void:
	print("HI")
	if single_trigger and triggered:
		player_inside_trigger = false
		return
	
	if not player_inside_trigger:
		if not interact_trigger:
			event.trigger()
			triggered = true
		player_inside_trigger = true

func _on_body_exited(body: Node2D) -> void:
	if not single_trigger:
		triggered = false
	player_inside_trigger = false

func _input(input_event):
	#print("input pressed")
	
	if GameState.dialogue_active:
		#print("dialogue is active!!")
		return

	if not interact_trigger:
		#print("bro aint an interact trigger")
		return
	
	if not player_inside_trigger:
		#print("bro aint inside the trigger area")
		return
	
	if triggered and single_trigger:
		
		return
		
	if input_event.is_action_pressed("interact"):
		print("trigger!!!")
		event.trigger()
		triggered = true			

func update_state_label():
	state_label.text = "Player inside trigger: " + str(player_inside_trigger)
	other_lab.text = "triggered = " + str(triggered)
func _process(d):
	update_state_label()
