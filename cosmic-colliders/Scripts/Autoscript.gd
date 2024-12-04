extends Node

# Global score variable
var score: int = 0

# Function to update the score label display
func update_score_display():
	if has_node("/root/Main Scene/Score"):
		var score_label = get_node("/root/Main Scene/Score")
		score_label.text = "Score: " + str(score)
	else:
		push_error("Score label not found.")
