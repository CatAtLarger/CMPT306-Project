extends Control

@export var high_scores_path = "res://high_scores.txt"

func _ready() -> void:
	update_high_score_ui()

func is_high_score(score: int) -> bool:
	var high_score_array = get_high_scores()
	
	for item in high_score_array:
		if score > item[1].to_int():
			return true
			
	return false


func set_high_score(initials: String, score: int):
	
	var high_score_array = get_high_scores()

	# Ensure maximum of 8 high scores
	if high_score_array.size() >= 8:
		# Check if the new score is higher than the lowest existing score
		if score <= int(high_score_array[-1][1]):
			return  # Don't add the new score if it's lower

	# Find the insertion point
	var i = 0
	while i < high_score_array.size() and score <= int(high_score_array[i][1]):
		i += 1

	# Insert the new score at the correct position
	high_score_array.insert(i, [initials, str(score)])

	# If the list exceeds 8, remove the lowest score
	if high_score_array.size() > 8:
		high_score_array.remove_at(8)

	save_to_file(high_score_array)  # Update the high scores in the game state
	return

func get_high_scores():
	var all_high_scores = load_from_file()
	var all_lines = all_high_scores.split("\n",false)
	var high_score_array = []
	for line in all_lines:

		high_score_array.append( [line.substr(0,3), line.substr(4)])

	return high_score_array


func save_to_file(content):
	var file = FileAccess.open(high_scores_path, FileAccess.WRITE)
	var content_string = ""
	for item in content:
		content_string += item[0] + " " + item[1] + "\n"
	file.store_string(content_string)
	file.close()

func load_from_file() -> String:
	var file = FileAccess.open(high_scores_path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	return content


func update_high_score_ui():
	var high_scores = get_high_scores()
	var high_score_ui_elements = $HighScores.get_children()
	for index in range(0,8):
		high_score_ui_elements[index].get_node("Name").text = high_scores[index][0]
		high_score_ui_elements[index].get_node("Score").text = high_scores[index][1]
		


func _on_game_over_menu_visibility_changed() -> void:
	if is_high_score(Autoscript.score):
		visible = true
		


func _on_line_edit_text_submitted(initials: String) -> void:
	set_high_score(initials, Autoscript.score)
	visible = false
