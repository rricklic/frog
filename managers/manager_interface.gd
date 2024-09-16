class_name ManagerInterface extends Node

# TODO: check that manager_scene is a Manager
"""
Adding @tool to the script and using get/set to validate the
exported property when someone tries to attach a PackedScene
that doesn't match what is expected. It's not perfect, but it's
still better than no checks at all. At least it makes type casting safe.
"""
@export var manager_scene: PackedScene

@onready var _manager_group: String = manager_scene.get_state().get_node_name(0)

func _create_manager() -> Node:
	var root: Node = get_tree().root
	assert(root.is_node_ready(), "Root is not ready. Cannot create and add manager. Connect to get_tree().root.ready and call manager interface from there.")
	
	var manager: Node = manager_scene.instantiate()
	root.add_child(manager)
	return manager

func _has_manager() -> bool:
	return get_tree().get_node_count_in_group(_manager_group) > 0

func _get_manager_priv() -> Node:
	return get_tree().get_first_node_in_group(_manager_group)

func _get_or_create_manager() -> Node:
	if (_has_manager()):
		return _get_manager_priv()
	return _create_manager()
	
static func get_interface(scene_tree: SceneTree, group: String) -> ManagerInterface:
	return scene_tree.get_first_node_in_group(group)
