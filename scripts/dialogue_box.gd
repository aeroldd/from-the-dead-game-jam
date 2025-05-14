extends Control

@onready var text_label = $Text
@onready var speaker_label = $SpeakerName

var current_text: Array[String] = []
var speaker = "None"

var in_progress = false

@onready var timer = $Timer

func _ready():
	visible = false
	text_label.text = "Hello"
	SignalBus.connect("show_dialogue", show_dialogue)
	
func show_text():
	text_label.text = current_text.pop_front()
	in_progress = true
	
func next_line():
	if current_text.size() > 0:
		show_text()
	else:
		finish()
		
func finish():
	visible = false
	text_label.text = ""
	speaker_label.text = ""
	in_progress = false
	print("dialogue finished!!")
	get_tree().paused = false
	timer.start()
	print("timer started")

func show_dialogue(dialogue: Dialogue):
	if not in_progress:
		current_text = dialogue.text.duplicate()
		visible = true
		in_progress = true
		GameState.dialogue_active = true
		
	if in_progress:
		next_line()

func _input(event):
	if in_progress and event.is_action_pressed("interact"):
		next_line()
	
func _on_timer_timeout() -> void:
	print("dialogue inactive now")
	GameState.dialogue_active = false
