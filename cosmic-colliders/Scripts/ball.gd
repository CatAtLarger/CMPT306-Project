extends RigidBody2D

#for gravity
var central_mass_position := Vector2(577,339)
@export var gravitational_constant := 5000.0


@onready var orbit = load("res://orbit.tscn")

#for loading next ball's scene after collision
@onready var celestial_objects = [
	load("res://Ball_Scenes/moon.tscn"),
	load("res://Ball_Scenes/dwarf_planet.tscn"),
	load("res://Ball_Scenes/planet.tscn"),
	load("res://Ball_Scenes/gas_giant.tscn"),
	load("res://Ball_Scenes/red_dwarf.tscn"),
	load("res://Ball_Scenes/blue_star.tscn"),
	load("res://Ball_Scenes/white_giant.tscn")
]
@export var celestial_index = 0


func _ready() -> void:
	
	var central_mass := get_node_or_null("CentralMass")
	
	if not central_mass == null:
		
		central_mass_position = central_mass.position
		
	else:
		push_warning("central_mass_position is hardcoded, cannot get \"Central Mass\" object" )

	



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

			#if not last ball
			if next_ball_index < celestial_objects.size() :
				#make new ball
				var next_ball_scene = celestial_objects[next_ball_index]
				var new_ball = next_ball_scene.instantiate()
				get_parent().call_deferred("add_child", new_ball)
				new_ball.position = collision_object.position
				
				
				#attach orbit to new child
				#orbit.connect("area_exited", new_ball, _on_orbit_area_exited)


			collision_object.queue_free()
			call_deferred("queue_free")
			
		
		
		
func _on_area_2d_area_entered(area: Area2D) -> void:
	
	var collision_object = area.get_parent()

	if is_in_group("balls"):

		if not is_queued_for_deletion() && not collision_object.is_queued_for_deletion():
			
			next_ball(collision_object)
		

func _on_orbit_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
