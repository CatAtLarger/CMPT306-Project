extends Node2D

class_name Evidence

var isDiscovered: bool
var evidenceType: String
var evidenceName: String

func _init() -> void:
	isDiscovered = get_meta("isDiscovered", false)
	evidenceName = get_meta("evidenceName", null)
	evidenceType = get_meta("evidenceType", null)

func _ready() -> void:
	pass
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
