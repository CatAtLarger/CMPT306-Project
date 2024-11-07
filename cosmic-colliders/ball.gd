extends RigidBody2D

#for gravity
var central_mass_position = Vector2.ZERO
var gravitational_constant = 5000.0




func _ready():
	central_mass_position = get_parent().get_parent().get_node("CentralMass").global_position



func _physics_process(delta):
	_apply_gravity(delta)



func _apply_gravity(delta):
	
	var direction = central_mass_position - global_position
	var distance = direction.length()

	if distance > 0:

		var force_magnitude = gravitational_constant / pow(distance, 2)
		var force = direction * force_magnitude

		# Apply the gravitational force
		apply_central_impulse(force * delta)


func next_ball():
	# Double the size of the ball
	scale *= 2

	var collision_shape = $CollisionShape2D.shape
	if collision_shape is CircleShape2D:
		collision_shape.radius *= 2
		
		
func _on_area_2d_area_entered(area: Area2D) -> void:
	print("Hit")
	var collision_object = area.get_parent()
	if is_in_group("balls"):
		
		collision_object.queue_free()
		next_ball()
