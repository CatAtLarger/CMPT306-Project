extends Area2D

@onready var boundary = $CollisionShape2D  # Adjust as necessary



func _ready() -> void:
	var boundary_radius = boundary.shape.radius
	print(boundary_radius)

 
