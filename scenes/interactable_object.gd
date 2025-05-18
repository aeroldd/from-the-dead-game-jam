extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var trigger_area = $InteractArea/TriggerArea

@export var data: InteractableObjectResource

func _ready() -> void:
	sprite.texture = data.sprite
	collision.shape = RectangleShape2D.new()
	collision.shape.extents = data.collision_box.size/2
	
	trigger_area.event = data.event
	
