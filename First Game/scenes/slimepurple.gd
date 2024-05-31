extends Node2D

const SPEED = 60
const FOLLOW_DISTANCE = 200  # The maximum distance at which the slime will start following the player

var player = null
var direction = 0  # Start with no movement
var path_following = false  # To track if the slime is following the path

@onready var ray_cast = $RayCast2D  # The RayCast2D node to check line of sight
@onready var animated_sprite = $AnimatedSprite2D
@onready var path2d = $Path2D  # The Path2D node
@onready var path_follow = $Path2D/PathFollow2D  # The PathFollow2D node

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")  # Ensure the player node is in the parent scene

func _process(delta):
	if player:
		var distance_to_player = position.distance_to(player.position)
		
		# Only follow if the player is within follow distance and in line of sight
		if distance_to_player < FOLLOW_DISTANCE and is_player_in_line_of_sight():
			path_following = true
		else:
			path_following = false

		if path_following:
			follow_path(delta)
		else:
			direction = 0  # Stop moving if the player is not within the follow distance or not in line of sight
			animated_sprite.stop()

		# Check for collision with the player
		if distance_to_player < 10:  # Adjust the distance as needed for collision detection
			player.die()  # Call the player's die function

# Function to check if the player is in line of sight
func is_player_in_line_of_sight() -> bool:
	var to_player = player.position - position
	ray_cast.force_raycast_update()  # Update the raycast
	return ray_cast.is_colliding() and ray_cast.get_collider() == player

# Function to follow the path
func follow_path(delta):
	var distance = SPEED * delta
	path_follow.offset += distance
	position = path_follow.position

	# Update the animation
	if path_follow.unit_offset < 1.0:
		animated_sprite.play("run")
		if path_follow.offset < path_follow.path_length / 2:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
