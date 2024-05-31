extends CharacterBody2D

class_name Player

const SPEED = 160.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
var is_invincible = false
var invincible_time = 2.0  # Time in seconds the player is invincible
var lives = 2  # Player starts with 2 lives
var state = "idle"
func _ready():
	add_to_group("player")

func _physics_process(delta):
	if state !="dead":
	# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

	# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	animated_sprite.flip_h = direction < 0

	# Play animations
	if state !="dead":
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			animated_sprite.play("jump")
		
		# Apply horizontal movement
		velocity.x = direction * SPEED

	# Flickering effect when invincible
	if is_invincible:
		# Make the sprite flicker by altering visibility
		visible = !visible

	# Apply movement
	move_and_slide()

func get_hit():
	if is_invincible:
		# If hit while invincible, the player dies
		die()
	else:
		# Become invincible after first hit
		is_invincible = true
		var timer = get_tree().create_timer(invincible_time)
		await timer.timeout
		end_invincibility()


func end_invincibility():
	# Reset invincibility state and make sure player is visible
	is_invincible = false
	visible = true
func die():
	if lives > 1:
		lives -= 1
		# Become invincible after losing a life
		get_hit()
	else:
		# Play death animation and wait for it to finish before reloading the scene
		state = "dead"
		animated_sprite.play("Death")  # Make sure "Death" is the name of your death animation
		velocity = Vector2.ZERO
		var timer = get_tree().create_timer(2.0)
		await timer.timeout
		print("Reloading scene")
		get_tree().reload_current_scene()  # Reload the current scene to restart the game
