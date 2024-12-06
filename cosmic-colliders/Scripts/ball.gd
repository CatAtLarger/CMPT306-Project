extends RigidBody2D

# for gravity
var central_mass_position = Vector2(577,339)
@export var gravitational_constant = 5000.0


# for loading next ball's scene after collision
@onready var celestial_objects: Array = [
	load("res://Scenes/Ball_Scenes/space_dust.tscn"),
	load("res://Scenes/Ball_Scenes/asteroid.tscn"),
	load("res://Scenes/Ball_Scenes/comet.tscn"),
	load("res://Scenes/Ball_Scenes/moon.tscn"),
	load("res://Scenes/Ball_Scenes/dwarf_planet.tscn"),
	load("res://Scenes/Ball_Scenes/planet.tscn"),
	load("res://Scenes/Ball_Scenes/gas_giant.tscn"),
	load("res://Scenes/Ball_Scenes/red_dwarf.tscn"),
	load("res://Scenes/Ball_Scenes/blue_star.tscn"),
	load("res://Scenes/Ball_Scenes/white_giant.tscn")
]

@export var celestial_index = 1000

# for effects
@onready var sound_effect = get_node("Effects/SoundEffect")


var has_collided = false


func _ready() -> void:
	
	#for finding central mass
	var central_mass := get_node_or_null("CentralMass")
	if central_mass != null:
		central_mass_position = central_mass.position
	else:
		push_warning("central_mass_position is hardcoded, cannot get \"Central Mass\" object")
		


func _physics_process(delta):
	_apply_gravity(delta)

func _apply_gravity(delta):
	var direction = central_mass_position - global_position
	var distance = direction.length()

	if distance > 0:
		var force_magnitude = gravitational_constant / pow(distance, 2)
		var force = direction * force_magnitude
		# apply the gravitational force
		apply_central_impulse(force * delta)

func next_ball(ball_index):
	
	var next_ball_index = ball_index + 1

	# if not last ball
	if next_ball_index >= celestial_objects.size():
		push_error("Cannot grab next index of last object in array.")
	
	
	#become invisible
	$Sprite2D.visible = false
	
	# make new ball
	var next_ball_scene = celestial_objects[next_ball_index]
	var new_ball = next_ball_scene.instantiate()
	get_parent().call_deferred("add_child", new_ball)
	new_ball.position = position
	Autoscript.tag_ball(new_ball)
	
	# Update score by adding double the current ball's value
	var ball_value = self.get_meta("value")  # Retrieve metadata value
	if ball_value != null:
		Autoscript.score += ball_value * 2  # Add twice the current ball's value
		Autoscript.update_score_display()  # Update score display
	else:
		push_warning("Ball instance has no metadata 'value'.")
			
	# Free the colliding ball after combining
	if new_ball:
		trigger_collision_effects()
		
	
			
func trigger_collision_effects():
	
	$Effects/CPUParticles2D.emitting = true
	sound_effect.play()
	
	if not sound_effect.playing:
		print("sound is not playing")
		sound_effect.play()

func _on_area_2d_area_entered(area: Area2D) -> void:
	
	
	
	var collision_object = area.get_parent()

	
	#if neither objects are balls
	if not is_in_group("balls") or not collision_object.is_in_group("balls"):
		return
	
	has_collided = true
	
	#if both objects have already been queued for deletion
	if is_queued_for_deletion() and collision_object.is_queued_for_deletion():
		return
		
	#if the image isn't the same	
	if  collision_object.get_child(1).texture != get_child(1).texture:
		return
		
	#if last ball	
	if (celestial_index + 1) >= celestial_objects.size():
		return
		
	if get_meta("ball_number") > collision_object.get_meta("ball_number"):
		next_ball( celestial_index)
	else:
		queue_free()



func _on_sound_effect_finished() -> void:
	call_deferred("queue_free")
