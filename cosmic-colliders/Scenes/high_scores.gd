extends Control

var high_scores_path = "res://high_scores.txt"

var high_score_file
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if not FileAccess.file_exists(high_scores_path):
		push_error(high_scores_path, "does not exist! Cannot update high scores!")
		return
	
	high_score_file = FileAccess.open(high_scores_path,FileAccess.READ)
	var high_scores = []
	while not high_score_file.eof_reached():
		var line = high_score_file.get_line()
		var initials = line.substr(0,3)
		var score = line.substr(4)
		high_scores.append([initials,score])
		
		
	for high_score in $HighScores.get_children():
		var next_score = high_scores.pop_front()
		high_score.get_node("Name").text = next_score[0]
		high_score.get_node("Score").text = next_score[1]
		
	high_score_file.close()
	
	print(set_high_score("JOK",1200))


func is_high_score(score) -> bool:
	if not FileAccess.file_exists(high_scores_path):
		push_error(high_scores_path, "does not exist! Cannot check high scores! Returning false.")
		return false
	
	high_score_file = FileAccess.open(high_scores_path,FileAccess.READ)
	while not high_score_file.eof_reached():
		var line = high_score_file.get_line()
		if line.substr(4).to_int() < score:
			high_score_file.close()
			return true
	high_score_file.close()
	return false

func set_high_score(initials: String, score: int):
	var all_high_scores = load_from_file()
	print(all_high_scores)


func save_to_file(content):
	var file = FileAccess.open(high_scores_path, FileAccess.WRITE)
	file.store_string(content)
	file.close()

func load_from_file() -> String:
	var file = FileAccess.open(high_scores_path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	return content
