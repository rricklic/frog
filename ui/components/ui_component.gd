class_name UIComponent extends Node

@export var target: Control

func _ready() -> void:
	if (target == null):
		target = get_parent()

	# Call _setup last after any potential containers set child control nodes
	_setup.call_deferred()
	
func _setup() -> void:
	pass
