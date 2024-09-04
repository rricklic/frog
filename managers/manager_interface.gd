class_name ManagerInterface extends Node

@export var manager_scene: PackedScene

var _target_group: String

func _setup(target_group: String) -> void:
	_target_group = target_group
	if (get_tree().get_node_count_in_group(_target_group) == 0):
		var manager: Node = manager_scene.instantiate()
		# Must call_deferred add_child since root may still have children being setup
		get_tree().root.add_child.call_deferred(manager)

func _get_manager() -> Node:
	return get_tree().get_first_node_in_group(_target_group)
