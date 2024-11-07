extends Node

# The player's current score
var score: int = 0

# Reference to the Label node in the UI
@onready var score_label = get_parent().get_node("UI/Label")

# Function to increase the score by a given amount
func increase_score(points: int) -> void:
	score += points
	update_score_display()

# Function to update the score display
func update_score_display() -> void:
	score_label.text = "Score: %d" % score
