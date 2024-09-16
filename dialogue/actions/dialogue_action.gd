class_name DialogueAction extends DialogueNode

func _init() -> void:
	printerr("Cannot initialize base class DialogueAction")
	assert(false, "Cannot initialize base class DialogueAction")

func execute(node: Node) -> void:
	pass
