extends Node2D  # Ensure this matches your node type


# Speed at which the background scrolls
var scroll_speed: float = 30.0
@onready var foreground1 = $Layer3/SpaceDust1
@onready var foreground2 = $Layer3/SpaceDust2


func _ready():
	loop_star_animations()
	
func _process(delta: float) -> void:
	moveForeground(delta)

func loop_star_animations():
	while true:
		for star in $Layer2.get_children():
			var delay = randf() * 2.0  # Generate a random delay
			star.play("default")
			await get_tree().create_timer(delay).timeout  # Wait for 2 seconds before repeating



func moveForeground(delta: float) -> void:
	
	foreground1.position.x -= scroll_speed * delta
	foreground2.position.x -= scroll_speed * delta
	
	if foreground1.position.x <= -foreground1.texture.get_size().x:
		foreground1.position.x = foreground2.position.x + foreground2.texture.get_size().x
		
	if foreground2.position.x <= -foreground2.texture.get_size().x:
		foreground2.position.x = foreground1.position.x + foreground1.texture.get_size().x
	
