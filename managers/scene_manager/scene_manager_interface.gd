class_name SceneManagerInterface extends ManagerInterface

func _ready() -> void:
	_setup(SceneManager.GROUP)

func switch_scenes(old_scene: Node, new_scene: PackedScene) -> void:
	var scene_manager: SceneManager = _get_manager()
	scene_manager.switch_scenes(old_scene, new_scene)

func delete_transition_sprite() -> void:
	var scene_manager: SceneManager = _get_manager()
	scene_manager.delete_transition_sprite()
