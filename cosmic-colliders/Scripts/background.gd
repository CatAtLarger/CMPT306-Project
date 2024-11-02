extends Node2D  # Ensure this matches your node type

@export var fog_scroll_speed: float = 30.0

@onready var foreground1 = $Layer3/SpaceDust1
@onready var foreground2 = $Layer3/SpaceDust2


@export var comet_speed: float = 30.0
@onready var comet = $Layer1/Comet

var comet_direction_x: float = randf_range(-(2 * PI), 2 * PI)
var comet_direction_y: float = randf_range(-(2 * PI), 2 * PI)


func _ready():
	loop_star_animations()
	
	
	while true:
		await get_tree().create_timer(10.0).timeout
		comet_direction_x = randf_range(0, 2 * PI)
		comet_direction_y = randf_range(0, 2 * PI)
		comet.rotation = atan2(comet_direction_y, comet_direction_x) + PI
		shoot_comet(comet_speed)
	
func _process(delta: float) -> void:
	move_foreground(delta)
	
	comet.position.x += comet_direction_x * delta * comet_speed
	comet.position.y += comet_direction_y * delta * comet_speed
	
	
	

func loop_star_animations():
	while true:
		for star in $Layer2.get_children():
			var delay = randf() * 2.0 
			star.play("default")
			await get_tree().create_timer(delay).timeout


func move_foreground(delta: float) -> void:
	foreground1.position.x -= fog_scroll_speed * delta
	foreground2.position.x -= fog_scroll_speed * delta

	# Get the width of each texture
	var width1 = foreground1.texture.get_width()
	var width2 = foreground2.texture.get_width()

	# Check if foreground1 has moved off-screen and reset its position
	if foreground1.position.x <= -width1:
		foreground1.position.x = (foreground2.position.x + width2) * 1.5

	# Check if foreground2 has moved off-screen and reset its position
	if foreground2.position.x <= -width2:
		foreground2.position.x = (foreground1.position.x + width1) * 1.5



func shoot_comet(speed: float) -> void:

	var screen_size = get_viewport().size

	# Choose a random direction (0 to 360 degrees)
	var angle = randf_range(0, 2 * PI)

	# Calculate the starting position off-screen
	var start_position = Vector2()

	if angle < PI / 2:
		# Top-right quadrant
		start_position = Vector2(screen_size.x + 100, -100)  # right side
	elif angle < PI:
		# Top-left quadrant
		start_position = Vector2(-100, -100)  # left side
	elif angle < 3 * PI / 2:
		# Bottom-left quadrant
		start_position = Vector2(-100, screen_size.y + 100)  # left side
	else:
		# Bottom-right quadrant
		start_position = Vector2(screen_size.x + 100, screen_size.y + 100)  # right side

	var comet = $Layer1/Comet


	
