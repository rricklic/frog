class_name DialogueBox extends Control

# a Dialogue can have multiple lines of text
# a line of text can be broken up into pages

signal finished

enum State {
	NONE,
	DISPLAYING,
	DISPLAYED,
	CHOOSE_RESPONSE,
	FINISHED,
	EXITING
}

enum Location {
	TOP,
	BOTTOM,
	TARGET
}

@export var max_width: int = 256
@export var max_lines: int = 3
@export var letter_delay: float = 0.03
@export var space_delay: float = 0.03
@export var punctuation_delay: float = 0.12
@export var dialogue: Dialogue
@export var next_page_texture: Texture
@export var response_select_texture: Texture
@export var margin: Vector2 = Vector2(16, 0)
@export var speed_up_factor: float = 5.0
@export var location: DialogueBox.Location = DialogueBox.Location.TARGET

var state: State = State.NONE
var text_pages: Array[String]
var text_page_index: int
var text_index: int
var speed_factor: float = 1.0
var time: float

@onready var dialogue_panel: Panel = %DialoguePanel
@onready var dialogue_label: Label = %DialogueLabel
@onready var response_panel: ResponsePanel = %ResponsePanel
@onready var audio_manager_interface: AudioManagerInterface = $AudioManagerInterface

func _ready() -> void:
	
	# TODO: improve using location to size/position dialogue box
	if (location == Location.BOTTOM || location == Location.TOP):
		max_width = get_viewport().size.x
	else:
		global_position = get_viewport().size / 2

	dialogue_label.position += margin / 2.0
	if (dialogue != null):
		display_dialogue(dialogue)
		
func display_dialogue(dialogue_to_display: Dialogue) -> void:
	text_pages = []
	dialogue = dialogue_to_display
	for dialogue_text in dialogue.text:
		text_pages.append_array(_format_text_to_display(dialogue_text))
	text_page_index = 0
	_display()
	
func _display() -> void:
	# TODO: transition in
	state = State.DISPLAYING
	text_index = 0
	speed_factor = 1.0
	response_panel.hide()
	_set_dialogue_box_size()
	_set_dialogue_box_position()
	set_process(true)

func _process(delta: float) -> void:
	time += delta
	_display_characters()

func _calc_text_pixel_size(text: String) -> Vector2:
	dialogue_label.text = text
	dialogue_label.reset_size()
	return dialogue_label.size

func _format_text_to_display(
		text: String
		) -> Array[String]:
	var text_pages: Array[String] = [""]
	var space_size: float = _calc_text_pixel_size(" ").x
	var row_size: float = 0
	var line_count: int = 1
	for word: String in text.split(" "):
		var word_size: float = _calc_text_pixel_size(word).x
		var add_space_size: float = 0
		if (row_size > 0):
			add_space_size = space_size
		
		if (row_size + word_size + add_space_size > max_width):
			row_size = 0
			add_space_size = 0
			if (line_count >= max_lines):
				line_count = 1
				text_pages.push_back("")
			else:
				line_count += 1
				text_pages[text_pages.size()-1] += "\n"

		if (add_space_size):
			text_pages[text_pages.size()-1] += " "
			row_size += add_space_size
		text_pages[text_pages.size()-1] += word
		row_size += word_size

	return text_pages
	
func _set_dialogue_box_size() -> void:
	dialogue_label.text = text_pages[text_page_index]
	dialogue_label.reset_size()
	dialogue_panel.size = dialogue_label.size + margin
	dialogue_panel.pivot_offset = dialogue_panel.size / 2.0
	dialogue_label.text = ""

func _set_dialogue_box_position() -> void:
	if (location == Location.BOTTOM):
		global_position = Vector2(0, get_viewport().size.y - dialogue_panel.size.y)
		size = Vector2(get_viewport().size.x, dialogue_panel.size.y)

func _get_character_delay_time(char: String) -> float:
	match (char):
		",", ".", "!", "?":
			return punctuation_delay / speed_factor
		" ":
			return space_delay / speed_factor
		_:
			return letter_delay / speed_factor

func _display_characters() -> void:
	if (text_index >= text_pages[text_page_index].length()):
		set_process(false)
		state = State.DISPLAYED
		return
	
	while (text_index < text_pages[text_page_index].length() && 
			time >= _get_character_delay_time(text_pages[text_page_index][text_index])):
		time -= _get_character_delay_time(text_pages[text_page_index][text_index])
		_display_character()

func _display_character() -> void:
	var char: String = text_pages[text_page_index][text_index]
	dialogue_label.text += char
	_play_sound()

	text_index += 1
	
func _play_sound() -> void:
	if (dialogue.sound):
		audio_manager_interface.play_audio(dialogue.sound, randf_range(0.95, 1.05))

func _choose_response() -> void:
	var response_index: int = response_panel.get_response_index()
	if (dialogue.responses[response_index].next_dialogue != null):
		display_dialogue(dialogue.responses[response_index].next_dialogue)
	else:
		_finished()

func _handle_finished() -> void:
	text_page_index += 1
	if (text_page_index < text_pages.size()):
		_display()
	elif (!dialogue.responses.is_empty()):
		state = State.CHOOSE_RESPONSE
		response_panel.set_responses(dialogue_panel, dialogue.responses)
	else:
		_finished()
	
func _unhandled_key_input(event: InputEvent) -> void:
	if (state == State.FINISHED):
		return
	if (Input.is_action_pressed("ui_accept") && state == State.DISPLAYING):
		accept_event()
		speed_factor = speed_up_factor
	if (Input.is_action_just_pressed("ui_accept") && state == State.CHOOSE_RESPONSE):
		accept_event()
		_choose_response()
	if (Input.is_action_just_pressed("ui_accept") && state == State.DISPLAYED):
		accept_event()
		_handle_finished()
		
func _finished() -> void:
	state = State.FINISHED
	finished.emit()
	# TODO: transition out
	hide()
