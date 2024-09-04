class_name MainMenu extends Control

@export var music: AudioStream
@export var selected_audio: AudioStream
@export var start_audio: AudioStream
@export var quit_audio: AudioStream
@export var trans_in_shader_params: ShaderParameters
@export var start_shader_params: ShaderParameters
@export var quit_shader_params: ShaderParameters

@onready var scene_manager_interface: SceneManagerInterface = $SceneManagerInterface
@onready var shader_manager_interface: ShaderManagerInterface = $ShaderManagerInterface
@onready var audio_manager_interface: AudioManagerInterface = $AudioManagerInterface

@onready var frogs: Node2D = %Frogs

@onready var title: Label = %Title
@onready var start_button: Button = %StartButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
	title.visible = false
	start_button.visible = false;
	quit_button.visible = false;
	
	_on_startup.call_deferred()
	start_button.mouse_entered.connect(_on_start_button_mouse_entered)
	quit_button.mouse_entered.connect(_on_quit_button_mouse_entered)
	quit_button.mouse_exited.connect(_on_quit_button_mouse_exited)
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
func _on_startup() -> void:
	scene_manager_interface.delete_transition_sprite()
	await shader_manager_interface.perform(self, trans_in_shader_params)
	audio_manager_interface.play_music(music)
	
	pivot_offset = size / 2.0
	title.pivot_offset = title.size / 2.0
	start_button.pivot_offset = start_button.size / 2.0
	quit_button.pivot_offset = quit_button.size / 2.0
	
	_rotate_pulse_title()
	_slide_in_buttons()

func _rotate_pulse_title() -> void:
	title.visible = true

	var duration: float = 0.5
	
	# Zoom in title
	var tween0: Tween = create_tween()
	tween0.set_ease(Tween.EaseType.EASE_OUT)
	tween0.set_trans(Tween.TransitionType.TRANS_QUART)
	tween0.tween_property(title, "scale", Vector2.ONE, 1).from(Vector2.ZERO)
	await tween0.finished

	# Rotate title
	var ease_type: Tween.EaseType = Tween.EASE_IN_OUT
	var trans_type: Tween.TransitionType = Tween.TRANS_SINE
	
	var tween: Tween = create_tween()
	tween.set_ease(ease_type)
	tween.set_trans(trans_type)
	tween.tween_property(title, "rotation_degrees", 10, duration)
	tween.tween_property(title, "rotation_degrees", 0, duration)
	tween.tween_property(title, "rotation_degrees", -10, duration)
	tween.tween_property(title, "rotation_degrees", 0, duration)
	tween.set_loops(-1)

	# Pulse scale title
	var tween2: Tween = create_tween()
	tween2.set_ease(ease_type)
	tween2.set_trans(trans_type)
	tween2.tween_property(title, "scale", Vector2(1.5, 1.5), duration)
	tween2.tween_property(title, "scale", Vector2(1, 1), duration)
	tween2.set_loops(-1)

func _slide_in_buttons() -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EaseType.EASE_OUT)
	tween.set_trans(Tween.TransitionType.TRANS_SPRING)
	tween.set_parallel(true)
	tween.tween_property(start_button, "global_position:x", start_button.global_position.x, 2).from(start_button.global_position.x - 500)
	tween.tween_property(quit_button, "global_position:x", quit_button.global_position.x, 2).from(quit_button.global_position.x + 500)
	start_button.visible = true;
	quit_button.visible = true;

func _on_start_button_mouse_entered() -> void:
	audio_manager_interface.play_audio(selected_audio)

func _on_quit_button_mouse_entered() -> void:
	audio_manager_interface.play_audio(selected_audio)
	for frog: Frog in frogs.get_children():
		frog.stop_jumping()
		
func _on_quit_button_mouse_exited() -> void:
	for frog: Frog in frogs.get_children():
		frog.start_jumping()

func _on_start_button_pressed() -> void:
	audio_manager_interface.play_audio(start_audio)
	await get_tree().create_timer(1).timeout
	shader_manager_interface.perform(self, start_shader_params)
	start_button.visible = false
	quit_button.visible = false
	audio_manager_interface.fade_out_volume(4)
	var tween: Tween = create_tween()
	tween.tween_property(self, "scale", Vector2(20, 20), 2)

func _on_quit_button_pressed() -> void:
	audio_manager_interface.play_audio(quit_audio)
	await get_tree().create_timer(1).timeout
	audio_manager_interface.fade_out_volume(4)
	await shader_manager_interface.perform(self, quit_shader_params)
	get_tree().quit()
