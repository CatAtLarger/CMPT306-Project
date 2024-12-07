extends CanvasLayer

@onready var pause_button = get_tree().root.get_node("Main Scene/UI/PauseButton")
@onready var resume_button = $Panel/ResumeButton

var is_game_paused = false  # Tracks the game's paused state

func _ready() -> void:
	# Ensure the GameControlsMenu processes input while paused
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Hide the GameControlsMenu at the start
	self.visible = false

	# Connect button signals to their respective functions
	pause_button.pressed.connect(_on_pause_button_pressed)
	resume_button.pressed.connect(_on_resume_button_pressed)

# Function to pause the game and show the menu
func _on_pause_button_pressed() -> void:
	if not is_game_paused:
		is_game_paused = true
		get_tree().paused = true  # Pause the game
		self.visible = true       # Show the GameControlsMenu

# Function to resume the game and hide the menu
func _on_resume_button_pressed() -> void:
	if is_game_paused:
		is_game_paused = false
		get_tree().paused = false # Resume the game
		self.visible = false      # Hide the GameControlsMenu
