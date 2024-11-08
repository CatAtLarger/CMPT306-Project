extends Area2D

# Set boundary for detecting out-of-bounds
@onready var boundary = $CollisionShape2D  # Adjust as necessary

var boundary_radius = 80 # boundary.shape.radius * boundary.scale.x

func _ready() -> void:
	push_warning("Boundary_radius hard coded!")

func _on_timer_timeout():
	for body in get_overlapping_bodies():

		if body is RigidBody2D:
			if body.global_position.distance_to(global_position) > boundary_radius:
				check_game_over()
			

func check_game_over():
	await get_tree().create_timer(3).timeout
	
	for body in get_overlapping_bodies():
		if body is RigidBody2D:
 
			if body.global_position.distance_to(global_position) > boundary_radius:
				print("Game Over")
