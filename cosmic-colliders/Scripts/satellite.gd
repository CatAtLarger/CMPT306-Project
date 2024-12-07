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
var ball_image_queue: Array = []  # Queue of ball images for the preview

# Center point and radius for dragging constraint
var center_point = Vector2(570, 340)
var drag_radius: float = 270
var is_dragging: bool = false
var previous_angle: float = 0.0  # To store the previous angle for direction detection

@export var drop_cooldown: float = 1  # Cooldown time in seconds
var can_drop: bool = true  # Flag to control dropping
@onready var drop_cooldown_timer = Timer.new()  # Timer for cooldown
@onready var score_label = get_tree().root.get_node("Main Scene/UI/Score")  # Score label reference

# References to the "Next Up" UI sprites
@onready var first_up = get_tree().root.get_node("Main Scene/UI/UpNext/FirstUp")
@onready var second_up = get_tree().root.get_node("Main Scene/UI/UpNext/SecondUp")
@onready var third_up = get_tree().root.get_node("Main Scene/UI/UpNext/ThirdUp")



func _ready() -> void:
	# Initialize the queue with 10 random celestial bodies
	for i in range(10):
		var next_ball_index = randi() % (ball_scenes.size() / 2)  # Restrict selection
		balls_queue.append(ball_scenes[next_ball_index])
		ball_image_queue.append(ball_images[next_ball_index])
	
	# Set the initial rotation so it faces the center from its starting position
	rotation_degrees = 0
	
	# Configure and start the cooldown timer
	drop_cooldown_timer.one_shot = true
	drop_cooldown_timer.wait_time = drop_cooldown
	add_child(drop_cooldown_timer)
	drop_cooldown_timer.timeout.connect(Callable(self, "_on_drop_cooldown_timeout"))
	
	# Display the current ball and update the "Next Up" UI
	get_next_ball()
	update_next_up_ui()

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			# Start dragging if the click is within the satellite's area
			# Initialize previous angle
			# Stop dragging when the mouse is released and attempt to drop the ball
			is_dragging = false
			if can_drop:
				$BallImage.visible = false
				$Effects/SoundEffect.play()
				drop_ball()
				
	else:
		if global_position.distance_to(event.global_position) <= drag_radius:
				is_dragging = true
				previous_angle = (global_position - center_point).angle()  

func _process(_delta):
	if is_dragging:
		var direction = (get_viewport().get_mouse_position() - center_point).normalized()
		global_position = center_point + direction * drag_radius
		var current_angle = (global_position - center_point).angle()
		var current_angle_degrees = rad_to_deg(current_angle)
		if current_angle < previous_angle:
			rotation_degrees -= abs(current_angle_degrees - rad_to_deg(previous_angle))
		else:
			rotation_degrees += abs(current_angle_degrees - rad_to_deg(previous_angle))
		rotation_degrees = fmod(rotation_degrees + 360, 360)
		previous_angle = current_angle

func drop_ball() -> void:
	if balls_queue.size() > 0:
		# Remove the first ball from the queue and instantiate it
		var ball_scene = balls_queue.pop_front()
		var ball_instance = ball_scene.instantiate()
		
		Autoscript.tag_ball(ball_instance)
		
		
		# Position the ball at the satellite's position
		ball_instance.position = self.global_position
		ball_instance.rotation = self.global_rotation
		get_parent().get_node("Balls").add_child(ball_instance)
		
		# Remove the corresponding image from the queue
		ball_image_queue.pop_front()
		
		# Add a new random ball to the end of the queue
		var next_ball_index = randi() % (ball_scenes.size() / 2)  # Restrict selection
		balls_queue.append(ball_scenes[next_ball_index])
		ball_image_queue.append(ball_images[next_ball_index])
		
		# Update the current ball and the "Next Up" UI
		get_next_ball()
		update_next_up_ui()
		can_drop = false
		drop_cooldown_timer.start()

func get_next_ball():
	# Update the ball being dropped
	if ball_image_queue.size() > 0:
		
		$BallImage.texture = ball_image_queue[0]
		$BallImage.scale = get_ball_scale($BallImage.texture.resource_path)
		

func get_ball_scale(texture_resource_path) -> Vector2:
	match texture_resource_path:
			"res://Images/Balls/space_dust.png":
				return Vector2(0.06, 0.06)
			"res://Images/Balls/asteroid.png":
				return Vector2(0.1, 0.1)
			"res://Images/Balls/comet.png":
				return Vector2(1.5, 1.5)
			"res://Images/Balls/moon.png":
				return Vector2(0.5, 0.5)
			"res://Images/Balls/dwarf_planet.png":
				return Vector2(0.6, 0.6)
			_:
				push_error("Unexpected ball in queue! Returning empty Vector2.")
				return Vector2(0,0)

func update_next_up_ui() -> void:
	
	var desired_diameter = 70
	# Update the "Next Up" sprites to display the next three balls in the queue
	if ball_image_queue.size() > 1:
		first_up.texture = ball_image_queue[1]
		first_up.scale = Vector2(desired_diameter,desired_diameter) / first_up.texture.get_size()
	if ball_image_queue.size() > 2:
		second_up.texture = ball_image_queue[2]
		second_up.scale = Vector2(desired_diameter,desired_diameter) / second_up.texture.get_size()
	if ball_image_queue.size() > 3:
		third_up.texture = ball_image_queue[3]
		third_up.scale = Vector2(desired_diameter,desired_diameter) / third_up.texture.get_size()

func _on_drop_cooldown_timeout() -> void:
	can_drop = true

func _on_sound_effect_finished() -> void:
	
	$BallImage.visible = true
	$Effects/CPUParticles2D.emitting = true
	$Effects/NewBallSound.play()
