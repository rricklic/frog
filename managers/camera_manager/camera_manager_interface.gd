class_name CameraManagerInterface extends ManagerInterface

const GROUP: String = "CameraManagerInterface"

func _ready() -> void:
	add_to_group(GROUP)

func apply_trauma(trauma: float) -> void:
	var manager: CameraManager = _get_or_create_manager()
	manager.apply_trauma(trauma)
