extends Node2D

var central_mass_position = Vector2.ZERO
var gravitational_constant = 5000.0
var rigidbody = RigidBody2D

func _ready():
	central_mass_position = get_parent().get_node("CentralMass").global_position
	rigidbody = get_node("RigidBody2D")

func _physics_process(delta):
	apply_gravity(delta, rigidbody)
	

func apply_gravity(delta, rigidbody):
	var direction = central_mass_position - global_position
	var distance = rigidbody.direction.length()

	if distance > 0:

		var force_magnitude = gravitational_constant / pow(distance, 2)
		var force = direction * force_magnitude

		# Apply the gravitational force
		rigidbody.apply_central_impulse(force * delta)


	
