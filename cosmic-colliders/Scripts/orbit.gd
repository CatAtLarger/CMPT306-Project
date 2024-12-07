extends Area2D

@onready var boundary = $CollisionShape2D  # Adjust as necessary
@onready var game_over_menu = get_tree().root.get_node("Main Scene/GameOverMenu")  # Reference to the GameOverMenu node

var boundary_radius = 0

func _ready() -> void:
	boundary_radius = boundary.shape.radius * boundary.scale.x


func _on_balls_child_entered_tree(node: Node) -> void:
	var ball_area = node.get_child(2)
	ball_area.connect("area_exited", on_area_exited)

func on_area_exited(area: Area2D):
	if $Timer.is_stopped():
		$Timer.start()


func _on_timer_timeout() -> void:
	var current_balls = get_parent().get_node("Balls").get_children()

	for ball in current_balls:
		var ball_radius = ball.get_child(0).shape.radius * ball.get_child(0).scale.x
		var distance_to_center = ball.global_position.distance_to($CollisionShape2D.global_position)
		if (distance_to_center > boundary_radius - ball_radius) and ball.has_collided:
			show_game_over()  # Trigger the Game Over logic
			return


func show_game_over():
	get_tree().paused = true  # Pause the game
	if game_over_menu:
		game_over_menu.visible = true  # Display the Game Over menu
	else:
		push_error("GameOverMenu node not found!")
	
