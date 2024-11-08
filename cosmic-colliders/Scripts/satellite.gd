extends Node2D

# List of ball (celestial object) scenes to load from, representing various celestial bodies
@export var ball_scenes: Array = [
	load("res://Ball_Scenes/moon.tscn"),
	load("res://Ball_Scenes/dwarf_planet.tscn"),
	load("res://Ball_Scenes/planet.tscn"),
	load("res://Ball_Scenes/gas_giant.tscn"),
	load("res://Ball_Scenes/red_dwarf.tscn"),
	load("res://Ball_Scenes/blue_star.tscn"),
	load("res://Ball_Scenes/white_giant.tscn")
]

var balls_queue: Array = []  # Queue of balls to be dropped

# Center point and radius for dragging constraint
var center_point = Vector2(570, 340)
var drag_radius: float = 270
var is_dragging: bool = false

func _ready() -> void:
	# Initialize the queue with 10 random celestial bodies
	for i in range(10):
		balls_queue.append(ball_scenes[randi() % ball_scenes.size()])

# Detect mouse events for starting/stopping dragging
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			# Start dragging if the click is within the satellite's area
			if global_position.distance_to(event.global_position) <= drag_radius:
				is_dragging = true
		else:
			# Stop dragging when the mouse is released and shoot the ball
			is_dragging = false
			drop_ball()

# Called every frame to update position if dragging
func _process(_delta):
	if is_dragging:
		# Calculate the direction from the center to the mouse position
		var direction = (get_viewport().get_mouse_position() - center_point).normalized()
		# Set the position within the radius around the center point
		global_position = center_point + direction * drag_radius

# Function to handle dropping a ball from the queue
func drop_ball() -> void:
	if balls_queue.size() > 0:
		# Remove the first ball from the queue and instantiate it
		var ball_scene = balls_queue.pop_front()
		var ball_instance = ball_scene.instantiate()
		
		# Position the ball at the satellite's position (ready to "drop" into orbit)
		ball_instance.position = self.global_position

		# Add the ball to the Balls node in the scene tree to make it part of the orbit
		get_parent().get_node("Balls").add_child(ball_instance)

		# Add a new random ball to the end of the queue to maintain queue size
		balls_queue.append(ball_scenes[randi() % ball_scenes.size()])
