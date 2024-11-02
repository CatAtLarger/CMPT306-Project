extends Node2D  # Ensure this matches your node type

@export var fog_scroll_speed: float = 30.0

@onready var foreground1 = $Layer3/SpaceDust1
@onready var foreground2 = $Layer3/SpaceDust2


@export var comet_speed: float
@onready var comet = $Layer1/Comet

var comet_direction_x: float = randf_range(-(2 * PI), 2 * PI)
var comet_direction_y: float = randf_range(-(2 * PI), 2 * PI)


func _ready():
	loop_star_animations()
	
	
	while true:
		await get_tree().create_timer(2.0).timeout
		#only if out of screen bounds
		if (comet.position.x < -300 || comet.position.x > (get_viewport().size.x*2 )) &&  (comet.position.y < -300 || comet.position.y > (get_viewport().size.y *2 )):
			
			comet_direction_x = randf_range(-( 2 * PI), 2 * PI)
			comet_direction_y = randf_range(-( 2 * PI), 2 * PI)
			comet.rotation = atan2(comet_direction_y, comet_direction_x) + PI
			set_comet_start_position(comet_direction_x, comet_direction_y)
	
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


# Function to set the comet's starting position based on direction
func set_comet_start_position(direction_x: float, direction_y: float) -> void:
	

	# Define the screen dimensions
	var screen_size = get_viewport().size

	if direction_x > 0:
		comet.position.x = -300 
		  # Start off the right side
	else:
		
		comet.position.x = screen_size.x*2 + 300 # Start off the left side

	if direction_y > 0:
		comet.position.y = -300
		  # Start off the bottom side
	else:
		comet.position.y = screen_size.y*2 + 300
		  # Start off the top side



	
		




	
