class_name DialogueManagerInterface extends ManagerInterface

func _ready() -> void:
	_setup(DialogueManager.GROUP)

func display(dialogue: Dialogue) -> void:
	var dialogue_manager: DialogueManager = _get_manager()
	dialogue_manager.display(dialogue)
