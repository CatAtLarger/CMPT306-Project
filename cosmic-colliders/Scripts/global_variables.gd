extends Node

# Global score variable
var score: int = 0

var ball_num = 0

# Function to update the score label display
func update_score_display():
	if has_node("/root/Main Scene/UI/Score"):
		var score_label = get_node("/root/Main Scene//UI/Score")
		score_label.text = "Score: " + str(score)
	else:
		push_error("Score label not found.")


func tag_ball(ball):
	ball_num+=1
	ball.set_meta("ball_number", ball_num)
