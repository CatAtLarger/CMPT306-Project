extends RigidBody2D

#for gravity
var central_mass_position := Vector2.ZERO
@export var gravitational_constant := 5000.0




#for loading next ball's scene after collision
@onready var celestial_objects = [
	preload("res://moon.tscn"),
	preload("res://dwarf_planet.tscn"),
	preload("res://planet.tscn"),
	preload("res://gas_giant.tscn"),
	preload("res://red_dwarf.tscn"),
	preload("res://blue_star.tscn"),
	preload("res://white_giant.tscn")
	
]
@export var celestial_index = 0

func _ready() -> void:
	
	if get_parent() != null:
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


func next_ball(collision_object):
	
		# if image is the same then must be same ball

		if collision_object.get_child(1).texture == get_child(1).texture:
			
			var next_ball_index = celestial_index + 1
			var next_ball_scene = celestial_objects[next_ball_index]
			
			
			if next_ball_scene:
				
				var new_ball = next_ball_scene.instantiate()


				
				get_parent().add_child(new_ball)
					
				new_ball.position = collision_object.position
				collision_object.queue_free()
				call_deferred("queue_free")
				
			else:
				push_error("Cannot get get next celestial_object!")
		
		
		
func _on_area_2d_area_entered(area: Area2D) -> void:
	
	var collision_object = area.get_parent()
	
	if is_in_group("balls"):
		
		if not is_queued_for_deletion() && not collision_object.is_queued_for_deletion():
			
			next_ball(collision_object)
		

func _on_orbit_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
