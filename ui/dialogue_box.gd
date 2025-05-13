extends Control

@onready var text_label = $Text
@onready var speaker_label = $SpeakerName

@export var text: Array[String] = ["Hi", "hello"]
var current_text: Array[String] = []
var speaker = "None"

var in_progress = false

func _ready():
	visible = false
	text_label.text = "Hello"
	SignalBus.connect("interact", _on_interact)
	
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

func _on_interact():
	if not in_progress:
		current_text = text.duplicate()
		visible = true
		in_progress = true
		
	if in_progress:
		next_line()
	
	print(text.size())
