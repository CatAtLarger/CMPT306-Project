extends RigidBody2D


var velocity = Vector2()

func _process(delta: float) -> void:
	move_and_slide(velocity)

func set_velocity(new_velocity: Vector2) -> void:
	velocity = new_velocity
