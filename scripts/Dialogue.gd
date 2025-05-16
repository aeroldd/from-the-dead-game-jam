extends Resource
class_name Dialogue

@export var raw_text: String:
	set(value):
		raw_text = value
		split_text()

var text: Array[String] = []
@export var dialogue_id: int
@export var speaker: String
@export var next_dialogue: Resource

@export var wait_time: float = 1

@export var conditional_dialogue: Array[ConditionalDialogue]
@export var set_flags: Array[String] # The flags that are going to be set after playing the dialogue

@export var options: Array[Option]

const MAX_LENGTH = 60

func split_text():
	text.clear()

	var words = raw_text.split(" ")
	var current_line = ""

	for word in words:
		# Handle explicit line breaks
		if "\\n" in word:
			var parts = word.split("\\n")
			for i in range(parts.size()):
				var part = parts[i]

				if current_line.length() + part.length() + 1 > MAX_LENGTH:
					text.append(current_line.strip_edges())
					current_line = ""

				current_line += part + " "
				
				# if not last part, break the line
				if i < parts.size() - 1:
					text.append(current_line.strip_edges())
					current_line = ""

		else:
			if current_line.length() + word.length() + 1 > MAX_LENGTH:
				text.append(current_line.strip_edges())
				current_line = ""

			current_line += word + " "

	if current_line.strip_edges() != "":
		text.append(current_line.strip_edges())
