class_name ChoicesPanel extends Panel

@export var margin: Vector2 = Vector2(16, 8)

var choices: Array[String]
var choice_index: int
var choice_size: Array[Vector2]

@onready var choices_label: Label = %ChoicesLabel
@onready var selection: ColorRect = %Selection

func _ready() -> void:
	choices_label.position += margin / 2.0

func _calc_response_size() -> void:
	for choice: String  in choices:
		choices_label.text = choice
		choices_label.reset_size()
		choice_size.push_back(choices_label.size)
	choices_label.text = ""

func disable() -> void:
	hide()
	set_process_unhandled_key_input(false)

# TODO: don't pass in dialogue_panel, calc position differently...
func set_choices(dialogue_panel: Panel, choices_arg: Array[String]) -> void:
	choices = choices_arg
	_calc_response_size()
	choice_index = 0
	for choice: String in choices:
		choices_label.text += choice + "\n"
	choices_label.reset_size()
	size = choices_label.size + margin
	position = dialogue_panel.position + Vector2(dialogue_panel.size.x, 0) + margin
	show()
	selection.show()
	_update_selection_position()

func _update_selection_position() -> void:
	selection.position = Vector2(0, choice_index * choice_size[choice_index].y) + (margin / 2)
	selection.size = Vector2(choices_label.size.x, choice_size[choice_index].y)

func _unhandled_key_input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("ui_up")):
		accept_event()
		choice_index = (choices.size() if choice_index == 0 else choice_index) - 1
		_update_selection_position()
	if (Input.is_action_just_pressed("ui_down")):
		accept_event()
		choice_index = (choice_index + 1) % choices.size()
		_update_selection_position()
		
func get_last_choice() -> String:
	if (choices.is_empty() || choices.size() <= choice_index):
		return ""
	return choices[choice_index]
