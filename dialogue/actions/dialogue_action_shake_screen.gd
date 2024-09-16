class_name DialogueActionShakeScreen extends DialogueAction

@export var trauma: float

func _init(trauma_arg: float) -> void:
	trauma = trauma_arg

func execute(node: Node) -> void:
	var interface: CameraManagerInterface = ManagerInterface.get_interface(node.get_tree(), CameraManagerInterface.GROUP)
	if (interface == null):
		return
	interface.apply_trauma(trauma)
