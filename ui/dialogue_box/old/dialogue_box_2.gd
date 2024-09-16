class_name DialogueBox2 extends MarginContainer

signal finished

@export var max_width: int = 256
@export var max_height: int = 256 # TODO: if height exceeded, break up dialogue
@export var letter_delay: float = 0.03
@export var space_delay: float = 0.03
@export var punctuation_delay: float = 0.2
@export var dialogue: Dialogue
@export var continue_texture: Texture
@export var arrow_texture: Texture

var text: String
var text_index: int
var dialogue_index: int

@onready var panel: Panel = %Panel
@onready var label: Label = %Label
@onready var margin_container: MarginContainer = %MarginContainer
@onready var timer: Timer = $Timer
@onready var audio_manager_interface: AudioManagerInterface = $AudioManagerInterface

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	timer.one_shot = true
	if (dialogue != null):
		display_dialogue(dialogue)

func display_dialogue(dialogue_to_display: Dialogue) -> void:
	dialogue = dialogue_to_display
	dialogue_index = 0
	_display_text(dialogue.text[dialogue_index])

func _display_text(text_to_display: String) -> void:
	text = text_to_display
	text_index = 0
	
	# Add newlines to dialogue text to keep width under max_witdth and 
	# compute dialogue box size 
	await _fit_dialogue()

	# Position dialogue box
	#global_position -= size / 2 # TODO:
	
	# Reset label and start displaying dialogue text
	label.text = ""
	_display_character()

# Add new lines to the dialogue test to display such that it does not exceed max_width
func _fit_dialogue() -> void:
	custom_minimum_size = Vector2.ZERO
	panel.custom_minimum_size = Vector2.ZERO
	margin_container.custom_minimum_size = Vector2.ZERO
	label.custom_minimum_size = Vector2.ZERO
	
	"""
	reset_size()
	update_minimum_size()
	queue_sort()

	size = Vector2.ZERO
	panel.size = Vector2.ZERO
	margin_container.size = Vector2.ZERO
	label.size  = Vector2.ZERO
	"""
	
	label.text = ""
	
	reset_size()
	update_minimum_size()
	queue_sort()
	
	label.text = " "
	

	await resized
	var size_x_space: float = 6 # TODO: label.size.x
	
	var words: PackedStringArray = text.split(" ")
	var size_x_array: Array[float] = []
	for word: String in words:
		label.text = word
		await resized
		size_x_array.push_back(label.size.x)
		label.text = ""
		await resized
	
	var max_x: float = 0
	var size_x: float = 0
	for i: int in range(0, words.size()):
		# Add word
		if (size_x + size_x_array[i] > max_width):
			label.text += "\n"
			size_x = 0
		label.text += words[i]
		size_x += size_x_array[i]
		max_x = max(size_x, max_x)
		
		# Add space
		if (i < words.size() - 1 && size_x + size_x_space > max_width):
			label.text += "\n"
			size_x = 0
		elif (i < words.size() - 1):
			label.text += " "
			size_x += size_x_space
		max_x = max(size_x, max_x)
		
	label.custom_minimum_size.x = max_x

	text = label.text
	label.text = ""
	label.text = text
	await resized
	custom_minimum_size.x = size.x
	custom_minimum_size.y = size.y

func _display_character() -> void:
	label.text += text[text_index]
		
	match (text[text_index]):
		",", ".", "!", "?":
			_play_sound()
			timer.start(punctuation_delay)
		" ":
			timer.start(space_delay)
		_:
			_play_sound()
			timer.start(letter_delay)

func _play_sound() -> void:
	if (dialogue.sound):
		audio_manager_interface.play_audio(dialogue.sound, randf_range(1.4, 1.8))

func _on_timer_timeout():
	text_index += 1
	if (text_index >= text.length()):
		_handle_finished()
	else:
		_display_character()
		
func _handle_finished() -> void:
	dialogue_index += 1
	if (dialogue_index < dialogue.text.size()):
		_display_text(dialogue.text[dialogue_index])
	else:
		finished.emit()
