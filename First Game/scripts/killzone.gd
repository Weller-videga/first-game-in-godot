extends Area2D
@onready var timer_2 = $Timer2

@onready var timer = $Timer

func _on_body_entered(_body):
	if _body.is_in_group("player"):
		if _body.is_invincible:
			# Player is invincible, do not kill them
			return
		else:
			# Player is not invincible, make them invincible and handle hit
			_body.get_hit()
			if _body.lives == 1 or _body.position.y > 145:
				# If player has only one life left, initiate death sequence
				_body.die()
			else:
				# If player has more than one life, make them invincible and start flicker effect
				_body.is_invincible = true
				_body.lives -= 1
				Engine.time_scale = 1.0
				timer.start()

func _on_timer_timeout():
	Engine.time_scale = 1.0
	# Reset the player to visible and not invincible
	var player = get_tree().get_root().get_node("Player") # Adjust the path to your player node
	if player:
		player.is_invincible = false
		player.visible = true

