extends Node

# Variable to keep track of the score
var score: int = 0

# Reference to the UI Label node to display the score
@onready var score_label: Label = get_parent().get_node("UI/Label")

func _ready() -> void:
	update_score_display()

# Function to update the score display in the UI
func update_score_display() -> void:
	score_label.text = "Score: " + str(score)

# Function to add score when a ball is dropped
func add_score_for_drop(ball: RigidBody2D) -> void:
	if ball.has_meta("value"):
		score += ball.get_meta("value")
		update_score_display()

# Function to add score when two balls combine
func add_score_for_combination(ball: RigidBody2D) -> void:
	if ball.has_meta("value"):
		score += ball.get_meta("value")
		update_score_display()
