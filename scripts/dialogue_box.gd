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

var just_started

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
		print("showing text")
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
	# Starting the new dialogue
	if not in_progress:
		# Just started flag set to add a one frame buffer between interacting with objects or events triggering and the skip dialogue option
		just_started = true
		
		# Determine what dialogue to use based on the conditions
		self.dialogue = get_correct_dialogue(dialogue)
		
		# Copy the text from the dialogue object in an array which will be used to go slide by slide
		current_text = self.dialogue.text.duplicate ()
		
		# Make the dialogue box visible
		visible = true
		in_progress = true
		GameState.dialogue_active = true
		
		speaker_label.text = self.dialogue.speaker
				
		# Defer reset of flag to next frame
		await get_tree().process_frame
		just_started = false
		
		# Update GameState flags to add the new states which the dialogue sets
		for flag in self.dialogue.set_flags:
			GameState.set_flag(flag, true)
		
		
	# Continuing the dialogue	
	if in_progress:
		next_line()

func _input(event):
	if in_progress and not just_started and event.is_action_pressed("interact"):
		print("moved to next line")
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
		SignalBus.emit_signal("event_finished")
		
	# Show dialogue options if there are dialogue options
	# Display the menu options if the dialogue has options
	if dialogue.options.size() != 0:
		show_dialogue_options()

func _on_wait_timeout() -> void:
	if next_dialogue != null:
		SignalBus.emit_signal("show_dialogue", next_dialogue)
		next_dialogue = null

# Conditional dialogue things
# Returns the correct dialogue based on the flags. Else it will play the default dialogue
func get_correct_dialogue(dialogue: Dialogue) -> Dialogue:

	for conditionals in dialogue.conditional_dialogue:
		var all_flags_true = true
		for condition in conditionals.conditions:
			if GameState.has_flag(condition):
				continue
			all_flags_true = false
		if all_flags_true:
			return conditionals.dialogue
	return dialogue

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
