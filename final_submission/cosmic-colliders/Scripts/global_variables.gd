extends Node

# Global score variable
var score: int = 0
var ball_num = 0

# Function to update the score label display (during gameplay)
func update_score_display():
	if has_node("/root/Main Scene/UI/Score"):
		var score_label = get_node("/root/Main Scene/UI/Score")
		score_label.text = "Score: " + str(score)
	else:
		push_error("Gameplay Score label not found.")

# Function to update the Game Over score label
func update_game_over_score():
	print("Updating Game Over Score Label")
	if has_node("/root/Main Scene/GameOverMenu/BackgroundLayer/ScoreLabel"):
		var game_over_score_label = get_node("/root/Main Scene/GameOverMenu/BackgroundLayer/ScoreLabel")
		game_over_score_label.text = "Final Score: " + str(score)
		print("Game Over Score updated:", score)
	else:
		push_error("Game Over Score label not found.")

# Function to tag a ball with a unique number
func tag_ball(ball):
	ball_num += 1
	ball.set_meta("ball_number", ball_num)
