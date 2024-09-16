class_name Test extends Node

func _ready() -> void:
	Engine.time_scale = 0
	await get_tree().create_timer(2, true, false, true).timeout
	Engine.time_scale = 1
