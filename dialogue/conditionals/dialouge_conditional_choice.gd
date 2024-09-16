class_name DialogueConditionalChoice extends DialogueConditional

@export var choice: String

func _init(choice_arg: String) -> void:
	choice = choice_arg

func execute(node: Node) -> bool:
	var interface: DialogueManagerInterface = ManagerInterface.get_interface(node.get_tree(), DialogueManagerInterface.GROUP)
	if (interface == null):
		return false
	return await interface.get_last_choice() == choice
