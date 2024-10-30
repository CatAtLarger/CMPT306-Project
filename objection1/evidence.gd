extends Node2D

class_name Evidence

var isDiscovered: bool
var evidenceType: String
var evidenceName: String

func _init() -> void:
	isDiscovered = get_meta("metadata/isDiscovered", false)
	evidenceName = get_meta("metadata/evidenceName", "None")
	evidenceType = get_meta("metadata/evidenceType", "None")

func _ready() -> void:
	pass
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
