extends Node2D  # Ensure this matches your node type

func _ready():
	loop_star_animations()

func loop_star_animations():
	while true:
		for star in $Layer2.get_children():
			var delay = randf() * 2.0  # Generate a random delay
			star.play("default")
			await get_tree().create_timer(delay).timeout  # Wait for 2 seconds before repeating
