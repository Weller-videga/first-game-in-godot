extends CharacterBody2D  # Using CharacterBody2D as requested

class_name PurbleSlime
var speed: float = 30.0

@onready var target = get_parent().find_node("Player")  # Locates the player in the scene hierarchy

func _ready():
	# Ensures target is set on ready; more robust game logic might be needed in actual games
	if target == null and get_tree().has_group("Player"):
		target = get_tree().get_nodes_in_group("Player")[0]

func _physics_process(_delta: float) -> void:  # Prefix unused parameter with underscore
	if target != null:
		var direction = position.direction_to(target.position)
		self.velocity = direction * speed  # Use self.velocity to refer to the CharacterBody2D velocity property
		move_and_slide()  # Use move_and_slide with no arguments if it manages velocity internally
