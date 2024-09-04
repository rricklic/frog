class_name SplashScreen extends ColorRect

@export var frog_croak_sound: AudioStream
@export var shader_parameters: ShaderParameters
@export var next_scene: PackedScene

@onready var audio_manager_interface: AudioManagerInterface = $AudioManagerInterface
@onready var shader_manager_interface: ShaderManagerInterface = $ShaderManagerInterface
@onready var scene_manager: SceneManager = $SceneManager

func _ready() -> void:
	await get_tree().create_timer(0.25).timeout
	audio_manager_interface.play_audio(frog_croak_sound)
	await get_tree().create_timer(2).timeout
	await shader_manager_interface.perform(self, shader_parameters)
	scene_manager.switch_scenes(self, next_scene)
