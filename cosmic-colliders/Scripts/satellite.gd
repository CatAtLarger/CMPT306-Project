extends Node2D

# Variable to track whether the satellite is being dragged
var is_dragging = false  
# Define a radius for detecting clicks near the center of the satellite
@export var drag_radius: float = 50.0  

# This function checks for input events (like mouse clicks)
func _input(event):
	# Start dragging when the mouse button is pressed
	if event is InputEventMouseButton and event.pressed:
		# Check if the click happened within the drag radius from the satellite's center
		if global_position.distance_to(event.global_position) <= drag_radius:
			is_dragging = true  # Set dragging to true

	# Stop dragging when the mouse button is released
	elif event is InputEventMouseButton and not event.pressed:
		is_dragging = false  # Set dragging to false

# Called every frame to update the satellite's position if it's being dragged
func _process(delta):
	# Only move the satellite if it's currently being dragged
	if is_dragging:
		# Set the satellite's position to the current mouse position
		global_position = get_viewport().get_mouse_position()
