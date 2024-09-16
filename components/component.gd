class_name Component extends Node

@export var target: Node

func _ready() -> void: 
	if (target == null):
		target = get_parent()
	_setup.call_deferred()

func _setup() -> void:
	pass
