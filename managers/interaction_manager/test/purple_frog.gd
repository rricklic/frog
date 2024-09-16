class_name PurpleFrog extends Sprite2D

@onready var interaction_area: InteractionArea = $InteractionArea

func _ready() -> void:
	interaction_area.interact = _interact
	
func _interact() -> void:
	print("INTERACT WITH PURPLE FROG")
	await get_tree().create_timer(1).timeout
	print("Done")
