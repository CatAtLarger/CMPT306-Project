extends Area2D

# Set boundary for detecting out-of-bounds
@onready var boundary = $CollisionShape2D  # Adjust as necessary

func _on_timer_timeout():
	for body in get_overlapping_bodies():

		if body is RigidBody2D:
			var boundary_radius = 80 # boundary.shape.radius * boundary.scale.x
			if body.global_position.distance_to(global_position) > boundary_radius:
				print(body.global_position.distance_to(global_position), "is greater than", boundary_radius)
				game_over()
				return
			else:
				print("False")

func game_over():
	print("Game Over!")
	# Additional game over logic here
