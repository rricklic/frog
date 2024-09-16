class_name DialogueManagerInterface extends ManagerInterface

const GROUP: String = "DialogueManagerInterface"

func _ready() -> void:
	add_to_group(GROUP)

# TODO: use dialogue_position; top/bottom alignment; follow target
func handle_dialogue_event(dialogue_event: DialogueEvent) -> void:
	var dialogue_manager: DialogueManager = _get_or_create_manager()
	dialogue_manager.handle_dialogue_event(dialogue_event)

func get_last_choice() -> String:
	var dialogue_manager: DialogueManager = _get_or_create_manager()
	return dialogue_manager.get_last_choice()
