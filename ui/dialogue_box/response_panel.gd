class_name ResponsePanel extends Panel

@export var margin: Vector2 = Vector2(16, 8)

var responses: Array[DialogueResponse]
var response_index: int
var reponse_size: Array[Vector2]

@onready var responses_label: Label = %ResponsesLabel
@onready var selection: ColorRect = %Selection

func _ready() -> void:
	responses_label.position += margin / 2.0

func _calc_response_size() -> void:
	for response: DialogueResponse in responses:
		responses_label.text = response.text
		responses_label.reset_size()
		reponse_size.push_back(responses_label.size)
	responses_label.text = ""

func set_responses(dialogue_panel: Panel, responses_to_display: Array[DialogueResponse]) -> void:
	responses = responses_to_display
	_calc_response_size()
	response_index = 0
	for response: DialogueResponse in responses:
		responses_label.text += response.text + "\n"
	responses_label.reset_size()
	size = responses_label.size + margin
	position = dialogue_panel.position + Vector2(dialogue_panel.size.x, 0) + margin
	show()
	selection.show()
	_update_selection_position()

func _update_selection_position() -> void:
	selection.position = Vector2(0, response_index * reponse_size[response_index].y) + (margin / 2)
	selection.size = Vector2(responses_label.size.x, reponse_size[response_index].y)

func _unhandled_key_input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("ui_up")):
		accept_event()
		response_index = (responses.size() if response_index == 0 else response_index) - 1
		_update_selection_position()
	if (Input.is_action_just_pressed("ui_down")):
		accept_event()
		response_index = (response_index + 1) % responses.size()
		_update_selection_position()
		
func get_response_index() -> int:
	return response_index
