extends RigidBody2D

var lock_movement = false  # Custom variable to control movement

func _physics_process(delta):
	if lock_movement:
		# Prevent movement when locked
		return

	var velocity = Vector2()  # Replace with your velocity handling logic
	move_and_slide(velocity)
