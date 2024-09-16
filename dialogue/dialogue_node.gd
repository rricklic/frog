class_name DialogueNode extends Resource

@export var text: String
@export var choices: Array[String]

func _init(text_arg: String = "test", choices_arg: Array[String] = []) -> void:
	text = text_arg
	choices = choices_arg
