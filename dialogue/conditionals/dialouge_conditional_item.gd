class_name DialogueConditionalItem extends DialogueConditional

@export var item: String

func _init(item_arg: String) -> void:
	item = item_arg

func execute(node: Node) -> bool:
	var interface: PlayerManagerInterface = ManagerInterface.get_interface(node.get_tree(), PlayerManagerInterface.GROUP)
	if (interface == null):
		return false
	return await interface.has_item(item)
