extends Node2D

# List of ball (celestial object) scenes to load from, representing various celestial bodies
@export var ball_scenes: Array = [
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
@export var ball_images: Array = [
	load("res://Images/Balls/space_dust.png"),
	load("res://Images/Balls/asteroid.png"),
	load("res://Images/Balls/comet.png"),
	load("res://Images/Balls/moon.png"),
	load("res://Images/Balls/dwarf_planet.png"),
	load("res://Images/Balls/planet.png"),
	load("res://Images/Balls/gas_giant.png"),
	load("res://Images/Balls/red_dwarf.png"),
	load("res://Images/Balls/blue_giant.png"),
	load("res://Images/Balls/white_giant.png")
]
var balls_queue: Array = []  # Queue of balls to be dropped
var ball_image_queue: Array = []

# Center point and radius for dragging constraint
var center_point = Vector2(570, 340)
var drag_radius: float = 270
var is_dragging: bool = false
var previous_angle: float = 0.0  # To store the previous angle for direction detection

@export var drop_cooldown: float = 1  # Cooldown time in seconds
var can_drop: bool = true  # Flag to control dropping
@onready var drop_cooldown_timer = Timer.new()  # Timer for cooldown
@onready var score_label = get_tree().root.get_node("Main Scene/Score")  # Score label reference



#to keep track of ball order
var ball_number = 0

func _ready() -> void:
	# Initialize the queue with 10 random celestial bodies
	for i in range(10):
		var next_ball_index = randi() % (ball_scenes.size() /2)
		balls_queue.append(ball_scenes[next_ball_index])
		ball_image_queue.append(ball_images[next_ball_index])
	
	# Set the initial rotation so it faces the center from its starting position
	rotation_degrees = 0
	
	
	# Configure and start the cooldown timer
	drop_cooldown_timer.one_shot = true
	drop_cooldown_timer.wait_time = drop_cooldown
	add_child(drop_cooldown_timer)
	drop_cooldown_timer.timeout.connect(Callable(self, "_on_drop_cooldown_timeout"))
	
	var next_ball_image = ball_image_queue.pop_front()
	$BallImage.texture = next_ball_image
	
	print($BallImage.texture.resource_path)
	#### inelegant quick and dirty solution
	match($BallImage.texture.resource_path):
		"res://Images/Balls/space_dust.png":
			$BallImage.scale = Vector2(-3.949,-3.949)
		"res://Images/Balls/asteroid.png":
			$BallImage.scale = Vector2(7.15,7.15)
		"res://Images/Balls/comet.png":
			$BallImage.scale = Vector2(9.15,9.15)
		"res://Images/Balls/moon.png":
			$BallImage.scale = Vector2(0.5,0.5)
		"res://Images/Balls/dwarf_planet.png":
			$BallImage.scale = Vector2(0.6,0.6)
		_:
			push_error("Grabbing a ball that should not be in the rotation of next balls!")
		

# Function to set the initial rotation based on the starting position
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			# Start dragging if the click is within the satellite's area
			if global_position.distance_to(event.global_position) <= drag_radius:
				is_dragging = true
				previous_angle = (global_position - center_point).angle()  # Initialize previous angle
		else:
			# Stop dragging when the mouse is released and attempt to drop the ball
			is_dragging = false
			if can_drop:
				drop_ball()

# Called every frame to update position if dragging
func _process(_delta):
	if is_dragging:
		# Calculate the direction from the center to the mouse position
		var direction = (get_viewport().get_mouse_position() - center_point).normalized()
		# Set the position within the radius around the center point
		global_position = center_point + direction * drag_radius
		
		# Calculate the current angle from the center to the satellite's position in radians
		var current_angle = (global_position - center_point).angle()
		
		# Convert the angle to degrees for rotation purposes
		var current_angle_degrees = rad_to_deg(current_angle)
		
		# Reverse the rotation direction by swapping the adjustments
		if current_angle < previous_angle:
			# Now, counterclockwise rotation
			rotation_degrees -= abs(current_angle_degrees - rad_to_deg(previous_angle))
		else:
			# Now, clockwise rotation
			rotation_degrees += abs(current_angle_degrees - rad_to_deg(previous_angle))
		
		# Normalize rotation to stay within 0 to 360 degrees
		rotation_degrees = fmod(rotation_degrees + 360, 360)
		
		# Update the previous angle
		previous_angle = current_angle

# Function to handle dropping a ball from the queue
func drop_ball() -> void:
	if balls_queue.size() > 0:
		# Remove the first ball from the queue and instantiate it
		var ball_scene = balls_queue.pop_front()
		
		var ball_instance = ball_scene.instantiate()
		
		ball_instance.set_meta("ball_number", ball_number)
		ball_number+=1
		
		# Position the ball at the satellite's position (ready to "drop" into orbit)
		ball_instance.position = self.global_position

		# Add the ball to the Balls node in the scene tree to make it part of the orbit
		get_parent().get_node("Balls").add_child(ball_instance)
		
		
		# Add a new random ball to the end of the queue to maintain queue size
		var next_ball_index = randi() % (ball_scenes.size() / 2)
		balls_queue.append(ball_scenes[next_ball_index])
		ball_image_queue.append(ball_images[next_ball_index-1])
		
		# Start cooldown after dropping the ball
		can_drop = false
		drop_cooldown_timer.start()
		
		
		

	
	
# Cooldown reset function
func _on_drop_cooldown_timeout() -> void:
	can_drop = true  # Allow another drop after cooldown

# Function to update the score label text
func update_score_display() -> void:
	if score_label:
		score_label.text = "Score: " + str(Autoscript.score)
	else:
		push_error("Score label not found.")

func update_next_ball_ui() -> void:
	pass
