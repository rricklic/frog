class_name TestDialogueMaanger extends Node

@onready var dialogue_manager_interface: DialogueManagerInterface = $DialogueManagerInterface

func _unhandled_key_input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("ui_up")):
		var dialogue: Dialogue = Dialogue.new()
		dialogue.text.push_back("Hello, world! This is an example dialogue for testing. La la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la la")
		dialogue_manager_interface.display(dialogue)
