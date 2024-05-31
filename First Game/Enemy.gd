extends CharacterBody2D

var speed = 50
var player_chase = false
var player = null

func _physics_process(delta):
	if player_chase and player != null:
		self.velocity = (player.position - position).normalized() * speed
		move_and_slide()  # Call move_and_slide with no arguments
	else:
		self.velocity = Vector2.ZERO  # Stop moving when not chasing

func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):  # Check if the body is the player
		player = body
		player_chase = true

func _on_detection_area_body_exited(body):
	if body == player:
		player = null
		player_chase = false
		self.velocity = Vector2.ZERO  # Stop moving immediately when player exits the area

func _on_kill_zone_body_entered(body):
	if body.is_in_group("Player"):
		# Damage the player or perform some action
		body.take_damage(10)  # Assuming the player has a method 'take_damage'

func _on_kill_zone_body_exited(body):
	if body == player:
		# Optionally do something when the player leaves the kill zone
		print("Player left the kill zone")
