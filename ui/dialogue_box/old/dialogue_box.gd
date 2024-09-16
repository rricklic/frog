class_name DialogueBoxOld extends MarginContainer

signal finished

enum State {
	NONE,
	DISPLAYING,
	CHOOSE_RESPONSE,
	FINISHED,
	EXITING
}

# character portraits; expressions
# transparency
# size and position - top, bottom, by character
# transition in/out - slide/fade/scale in/out
# TODO: next dialogue without response

@export var text_speed: int = 20 # characters per second
@export var dialogue: Dialogue

var time_to_display: float
var time: float
var speed_factor: float = 1.0
var state: State = State.NONE
var next_dialogue: Dialogue = null
var text_index: int = 0
var response_index: int = 0

@onready var text: Label = %Text
@onready var cursor: TextureRect = %Cursor
@onready var ocsillation_movement: OcsillationMovement = %OcsillationMovement
@onready var response_panel: Panel = %ResponsePanel
@onready var response_text: Label = %ResponseText
@onready var v_box_container: VBoxContainer = %VBoxContainer
@onready var dialogue_panel: Panel = %DialoguePanel

func _ready() -> void:
	pivot_offset = size / 2.0
	if (dialogue != null):
		display(dialogue)
	
func display(dialogue_to_display: Dialogue, is_trans_in: bool = true) -> void:
	dialogue = dialogue_to_display
	text_index = 0
	_display_text(dialogue.text[text_index], is_trans_in)

func _display_text(text_to_display: String, is_trans_in: bool) -> void:
	set_physics_process(false)
	state = State.DISPLAYING
	cursor.hide()
	response_panel.hide()
	text.text = text_to_display
	text.visible_ratio = 0.0
	time_to_display = text.text.length() / float(text_speed)
	time = 0.0
	next_dialogue = null
	if (is_trans_in):
		await _transition_in()
		await get_tree().create_timer(0.2).timeout
	set_physics_process(true)

func _display_cursor() -> void:
	cursor.show()
	# Wait for container to position cursor
	await get_tree().process_frame
	ocsillation_movement.ocscillate()
	state = State.FINISHED

func _display_response() -> void:
	response_panel.show()
	response_text.text = ""
	for response: DialogueResponse in dialogue.responses:
		if (response_text.text.length() > 0):
			response_text.text += "\n"
		response_text.text += response.text
		
	#response_panel.size.y = response_text.size.y
	#v_box_container.minimum_size.y += 100

	state = State.CHOOSE_RESPONSE

func _physics_process(delta: float) -> void:
	time += delta * speed_factor
	text.visible_ratio = time / time_to_display
	if (text.visible_ratio >= 1.0):
		set_physics_process(false)
		text_index += 1
		if (text_index >= dialogue.text.size() && dialogue.responses.size() > 0):
			_display_response()
		else:
			_display_cursor()

func _transition_in() -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EaseType.EASE_OUT)
	tween.set_trans(Tween.TransitionType.TRANS_QUART)
	tween.tween_property(self, "scale", Vector2.ONE, 1).from(Vector2.ZERO)
	await tween.finished
	
	"""
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EaseType.EASE_OUT)
	tween.set_trans(Tween.TransitionType.TRANS_QUART)
	tween.set_parallel(true)
	tween.tween_property(self, "global_position:y", global_position.y, 1).from(get_viewport().get_visible_rect().size.y)
	tween.tween_property(self, "modulate:a", 1.0, 1).from(0.0)
	await tween.finished
	"""
	
func _transition_out() -> void:
	var original_y: float = global_position.y
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EaseType.EASE_OUT)
	tween.set_trans(Tween.TransitionType.TRANS_CUBIC)
	tween.set_parallel(true)
	tween.tween_property(self, "global_position:y", get_viewport().get_visible_rect().size.y, 1)
	tween.tween_property(self, "modulate:a", 0.0, 1)
	await tween.finished
	global_position.y = original_y
	modulate.a = 1.0

func _unhandled_key_input(event: InputEvent) -> void:
	if (state == State.EXITING):
		return
	if (Input.is_action_pressed("ui_accept") && text.visible_ratio < 1.0):
		accept_event()
		speed_factor = 5.0
	if (Input.is_action_just_released("ui_accept") && text.visible_ratio < 1.0):
		accept_event()
		speed_factor = 1.0
	if (Input.is_action_just_pressed("ui_accept") && text.visible_ratio >= 1.0 && state == State.CHOOSE_RESPONSE):
		accept_event()
		state = State.FINISHED
		next_dialogue = dialogue.responses[response_index].next_dialogue
	if (Input.is_action_just_pressed("ui_up") && state == State.CHOOSE_RESPONSE):
		response_index = (dialogue.responses.size() if response_index == 0 else response_index) - 1
		print("response_index=" + str(response_index))
	if (Input.is_action_just_pressed("ui_down") && state == State.CHOOSE_RESPONSE):
		response_index = (response_index + 1) % dialogue.responses.size()
		print("response_index=" + str(response_index))
	if (Input.is_action_just_pressed("ui_accept") && text.visible_ratio >= 1.0 && state == State.FINISHED):
		state = State.EXITING
		accept_event()
		cursor.hide()
		if (text_index < dialogue.text.size()):
			_display_text(dialogue.text[text_index], false)
		elif (next_dialogue):
			display(next_dialogue, false)
		else:
			await _transition_out()
			finished.emit()
