extends RigidBody2D

#for gravity
var central_mass_position = Vector2.ZERO
var gravitational_constant = 5000.0


#for collisions
@export var image_array = [
	preload("res://Images/Balls/star_red_giant01.png"),
	preload("res://Images/Balls/star_blue_giant01.png"),
	preload("res://Images/Balls/star_white_giant04.png")
]
var current_image_index = 0
var sprite: Sprite2D

func _ready():
	central_mass_position = get_parent().get_node("CentralMass").global_position
	sprite = get_node("Sprite2D")


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

	# Move to the next image in the array

	current_image_index += 1
	if current_image_index < image_array.size():
		print("Texture before:", sprite.texture)
		sprite.texture = image_array[current_image_index]
		print("Texture after:", sprite.texture)
	
	
	else:
		current_image_index = image_array.size() - 1  # Cap at the last image

	var collision_shape = $CollisionShape2D.shape
	if collision_shape is CircleShape2D:
		collision_shape.radius *= 2
		
		
func _on_area_2d_area_entered(area: Area2D) -> void:
	var collision_object = area.get_parent()
	if is_in_group("balls"):
		collision_object.queue_free()
		next_ball()
