extends CharacterBody2D

# Define states as an enum for clarity
enum State {IDLE, WALKING, IMMOVABLE}

# Player properties
@export var SPEED: float = 300.0

# Node references
@onready var animated_sprite = $AnimatedSprite2D
@onready var interaction_area = $Area2D
@onready var state_label = $StateLabel  # Reference the existing StateLabel node

# State variables
var current_state = State.IDLE
var last_direction = Vector2.DOWN

func _ready():
	# Initialize state
	change_state(State.IDLE)

func _physics_process(_delta: float) -> void:
	# Execute current state logic
	match current_state:
		State.IDLE:
			process_idle_state()
		State.WALKING:
			process_walking_state()
		State.IMMOVABLE:
			process_immovable_state()
	
	# Common logic for all states
	move_and_slide()
	update_interaction_area()

func change_state(new_state):
	# Set new state
	current_state = new_state
	
	# Update state label
	match new_state:
		State.IDLE:
			state_label.text = "Current State: Idle"
			update_idle_animation()
		State.WALKING:
			state_label.text = "Current State: Walking"
		State.IMMOVABLE:
			state_label.text = "Current State: Immovable"
			velocity = Vector2.ZERO

# State-specific processing functions
func process_idle_state():
	var direction = get_input_direction()
	
	if direction:
		# If we have movement input, transition to walking
		last_direction = direction.normalized()
		change_state(State.WALKING)
	else:
		# No input, remain idle and stop movement
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

func process_walking_state():
	var direction = get_input_direction()
	
	if direction:
		# Continue walking
		direction = direction.normalized()
		last_direction = direction
		velocity = direction * SPEED
		update_walking_animation(direction)
	else:
		# No more input, return to idle
		change_state(State.IDLE)

func process_immovable_state():
	# In immovable state, the player can't move
	# All input is ignored
	velocity = Vector2.ZERO
	
	# Note: To exit this state, an external call to change_state() is needed

# Helper functions
func get_input_direction():
	# Only process input if not in IMMOVABLE state
	if current_state == State.IMMOVABLE:
		return Vector2.ZERO
		
	return Vector2(
		Input.get_axis("left", "right"), 
		Input.get_axis("up", "down")
	)

func update_walking_animation(direction):
	if abs(direction.x) > abs(direction.y):
		# Horizontal movement
		if direction.x > 0:
			animated_sprite.play("walk_right")
		else:
			animated_sprite.play("walk_left")
	else:
		# Vertical movement
		if direction.y > 0:
			animated_sprite.play("walk_down")
		else:
			animated_sprite.play("walk_up")

func update_idle_animation():
	if abs(last_direction.x) > abs(last_direction.y):
		if last_direction.x > 0:
			animated_sprite.play("idle_right")
		else:
			animated_sprite.play("idle_left")
	else:
		if last_direction.y > 0:
			animated_sprite.play("idle_down")
		else:
			animated_sprite.play("idle_up")

func update_interaction_area() -> void:
	# Reset Area2D position first
	interaction_area.position = Vector2.ZERO
	
	# Position the Area2D based on facing direction
	if abs(last_direction.x) > abs(last_direction.y):
		# Facing horizontally
		if last_direction.x > 0:
			# Right
			interaction_area.rotation_degrees = 270
		else:
			# Left
			interaction_area.rotation_degrees = 90
	else:
		# Facing vertically
		if last_direction.y > 0:
			# Down
			interaction_area.rotation_degrees = 0
		else:
			# Up
			interaction_area.rotation_degrees = 180

# Public functions to control state externally
func set_immovable(value: bool):
	if value:
		change_state(State.IMMOVABLE)
	else:
		change_state(State.IDLE)
