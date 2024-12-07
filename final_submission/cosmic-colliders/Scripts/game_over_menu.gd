extends CanvasLayer

# Called when "Play Again" button is pressed
func _on_play_again_button_pressed():
	get_tree().paused = false  # Resume the game
	get_tree().reload_current_scene()  # Reload the current scene

# Called when "Exit" button is pressed
func _on_exit_button_pressed():
	get_tree().quit()  # Quit the game

# Ensure GameOverMenu processes input while the game is paused
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # Keep processing input even when the game is paused
