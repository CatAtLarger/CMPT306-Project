extends Node2D

@export var petName: String
@export var skin: String
@export var sicknessChance: float
@export var hungerAmount: int
@export var thirstAmount: int
@export var boredomAmount: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func getSickChance(sicknessChance: float) -> bool:
	return false
	
