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

# Array to hold the queue of balls to be dropped, initialized to a size of 10
var balls_queue: Array = []

func _ready() -> void:
	# Initialize the queue with 10 random celestial bodies
	for i in range(10):
		balls_queue.append(ball_scenes[randi() % ball_scenes.size()])

# Detect mouse click input to trigger ball drop
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		drop_ball()  # Drop the ball when the mouse button is clicked

# Function to handle dropping a ball from the queue
func drop_ball() -> void:
	# Check if there are balls to drop
	if balls_queue.size() > 0:
		# Remove the first ball from the queue and instantiate it
		var ball_scene = balls_queue.pop_front()
		var ball_instance = ball_scene.instantiate()
		
		# Position the ball at the satellite's position (ready to "drop" into orbit)
		ball_instance.position = self.position

		# Add the ball to the Balls node in the scene tree to make it part of the orbit
		get_parent().get_node("Balls").add_child(ball_instance)

		# Add a new random ball to the end of the queue to maintain queue size
		balls_queue.append(ball_scenes[randi() % ball_scenes.size()])
