class_name DialogueBox extends Control

# a Dialogue can have multiple lines of text
# a line of text can be broken up into pages

signal finished

enum State {
	NONE,
	DISPLAYING,
	DISPLAYED,
	CHOOSE,
	FINISHED
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
@export var next_page_texture: Texture
@export var choice_select_texture: Texture
@export var margin: Vector2 = Vector2(16, 0)
@export var speed_up_factor: float = 5.0
@export var location: DialogueBox.Location = DialogueBox.Location.TARGET

@export var text: String
@export var choices: Array[String]

var text_pages: Array[String]
var state: State = State.NONE
var text_page_index: int
var text_index: int
var speed_factor: float = 1.0
var time: float

@onready var dialogue_panel: Panel = %DialoguePanel
@onready var dialogue_label: Label = %DialogueLabel
@onready var choices_panel: ChoicesPanel = %ChoicesPanel
@onready var audio_manager_interface: AudioManagerInterface = $AudioManagerInterface

func _ready() -> void:
	# TODO: improve using location to size/position dialogue box
	#if (location == Location.BOTTOM || location == Location.TOP):
	#	max_width = get_viewport().size.x
	#else:
	global_position = get_viewport().size / 2

	dialogue_label.position += margin / 2.0
	if (text != "" || !choices.is_empty()):
		display(text, choices, global_position)

func disable() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	
func enable() -> void:
	show()
	process_mode = Node.PROCESS_MODE_INHERIT

func display(text_arg: String, choices_arg: Array[String], dialogue_position: Vector2) -> void:
	if (text_arg == ""):
		finished.emit()
		return

	enable()

	text_pages = _format_text_to_display(text_arg)
	choices = choices_arg
	text_page_index = 0
	await _display(dialogue_position)
	
func _display(dialogue_position: Vector2) -> void:
	# TODO: transition in
	state = State.DISPLAYING
	text_index = 0
	speed_factor = 1.0
	choices_panel.disable()
	_set_dialogue_box_size()
	_set_dialogue_box_position(dialogue_position)
	set_process(true)
	await finished

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

func _set_dialogue_box_position(dialogue_position: Vector2) -> void:
	dialogue_panel.global_position = Vector2(
				dialogue_position.x - dialogue_panel.size.x / 2, 
				dialogue_position.y - dialogue_panel.size.y)
	print(dialogue_panel.global_position)
	#if (location == Location.BOTTOM):
	#	global_position = Vector2(0, get_viewport().size.y - dialogue_panel.size.y)
	#	size = Vector2(get_viewport().size.x, dialogue_panel.size.y)

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
	#if (dialogue.sound):
	#	audio_manager_interface.play_audio(dialogue.sound, randf_range(0.95, 1.05))
	pass # TODO:

func get_last_choice() -> String:
	return choices_panel.get_last_choice()

func _handle_accept() -> void:
	text_page_index += 1
	if (text_page_index < text_pages.size()):
		_display(global_position)
	elif (state == State.DISPLAYED && !choices.is_empty()):
		state = State.CHOOSE
		choices_panel.set_choices(dialogue_panel, choices)
		choices_panel.set_process_unhandled_key_input(true)
	else:
		_finished()
	
func _unhandled_key_input(event: InputEvent) -> void:
	if (state == State.FINISHED):
		return
	if (Input.is_action_pressed("ui_accept") && state == State.DISPLAYING):
		accept_event()
		speed_factor = speed_up_factor
	if (Input.is_action_just_pressed("ui_accept") && state == State.CHOOSE):
		accept_event()
		_handle_accept()
	if (Input.is_action_just_pressed("ui_accept") && state == State.DISPLAYED):
		accept_event()
		_handle_accept()
		
func _finished() -> void:
	state = State.FINISHED
	finished.emit()
	# TODO: transition out
