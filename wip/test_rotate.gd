class_name TestRotate extends Node

@onready var rotate_spring_component: RotateSpringComponent = $Sprite2D/RotateSpringComponent

func _unhandled_key_input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("ui_accept")):
		rotate_spring_component.trigger()
