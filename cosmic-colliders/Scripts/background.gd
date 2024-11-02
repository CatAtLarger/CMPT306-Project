extends Node2D  # Ensure this matches your node type


# Speed at which the background scrolls
@export var scroll_speed: float = 30.0
@onready var foreground1 = $Layer3/SpaceDust1
@onready var foreground2 = $Layer3/SpaceDust2


func _ready():
	loop_star_animations()
	
func _process(delta: float) -> void:
	move_foreground(delta)

func loop_star_animations():
	while true:
		for star in $Layer2.get_children():
			var delay = randf() * 2.0 
			star.play("default")
			await get_tree().create_timer(delay).timeout


func move_foreground(delta: float) -> void:
	foreground1.position.x -= scroll_speed * delta
	foreground2.position.x -= scroll_speed * delta

	# Get the width of each texture
	var width1 = foreground1.texture.get_width()
	var width2 = foreground2.texture.get_width()

	# Check if foreground1 has moved off-screen and reset its position
	if foreground1.position.x <= -width1:
		foreground1.position.x = (foreground2.position.x + width2) * 1.5

	# Check if foreground2 has moved off-screen and reset its position
	if foreground2.position.x <= -width2:
		foreground2.position.x = (foreground1.position.x + width1) * 1.5
