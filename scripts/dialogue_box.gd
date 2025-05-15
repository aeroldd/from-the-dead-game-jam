extends Control

@onready var text_label = $Text
@onready var speaker_label = $SpeakerName

var current_text: Array[String] = []
var speaker = "None"

var in_progress = false

@onready var timer = $Timer
@onready var wait_timer = $Wait

var dialogue: Dialogue
var next_dialogue: Dialogue = null

@onready var options_menu = $Options

func _ready():
	visible = false
	text_label.text = ""
	
	SignalBus.connect("show_dialogue", show_dialogue)
	SignalBus.connect("dialogue_finished", _on_dialogue_finished)
	
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

	timer.start()
		
	SignalBus.emit_signal("dialogue_finished", dialogue)

func show_dialogue(dialogue: Dialogue):
	if not in_progress:
		current_text = dialogue.text.duplicate()
		visible = true
		in_progress = true
		GameState.dialogue_active = true
		speaker_label.text = dialogue.speaker
		self.dialogue = dialogue
		
		# Display the menu options if the dialogue has options
		if dialogue.options.size() != 0:
			show_dialogue_options()
				
	if in_progress:
		next_line()

func _input(event):
	if in_progress and event.is_action_pressed("interact"):
		next_line()
	
func _on_timer_timeout() -> void:
	print("dialogue inactive now")
	GameState.dialogue_active = false
	
func _on_dialogue_finished(dialogue: Dialogue) ->void:
	print("dialogue finished!")
	next_dialogue = dialogue.next_dialogue
	if next_dialogue != null:
		wait_timer.wait_time = next_dialogue.wait_time
		wait_timer.start()	
	else:
		get_tree().paused = false

func _on_wait_timeout() -> void:
	if next_dialogue != null:
		SignalBus.emit_signal("show_dialogue", next_dialogue)
		next_dialogue = null

# Dialogue options menu related things

func init_dialogue_options():
	# Clear all the buttons in the dialogue options area
	for child in options_menu.get_children():
		child.queue_free()

func show_dialogue_options():
	init_dialogue_options()
	
	var dialogue_options = dialogue.options
	
	for option in dialogue_options:
		var button = Button.new()
		button.text = option.option_name
		options_menu.add_child(button)
