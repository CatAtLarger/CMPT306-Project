extends Node2D  # Make sure this matches your node type

func _ready():

	for star in $Layer2.get_children():
		var delay = randf() * 2.0
		start_animation_with_delay(star, delay)


func start_animation_with_delay(animated_sprite: AnimatedSprite2D, delay: float):
	await get_tree().create_timer(delay).timeout
	animated_sprite.play("default") 
