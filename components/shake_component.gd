class_name ShakeComponent extends Node

# Math for Game Programmers: Juicing Your Cameras With Math 
# https://www.youtube.com/watch?v=tu-Qe66AvtY&t=949s
# 09:54 - equations
# 14:00 - noise vs random
# 15:25 - take away

# You're not using Godot to its potential (components)
# https://www.youtube.com/watch?v=ldxDJpRPCMI&t=7s
# Designing and accessing components

# Trauma based screen shake
# supports directional and rotational shake
# time scaled
# linear trauma recovery with adjustable factor value recovery_factor
# linear, quadratic, or cubic shake factor based on trauma
# target must have 
#   offset: Vector2
#   angle_offset: float


const META_NAME: String = "ShakeComponent" 

enum ShakeCalculation {
	TRAUMA,
	TRAUMA_SQUARED,
	TRAUMA_CUBED
}

@export var noise: FastNoiseLite = FastNoiseLite.new()
@export var noise_speed: float = 1000.0
@export var max_angle: float = 15.0 ## degrees
@export var max_offset_x: float = 50.0 ## pixels
@export var max_offset_y: float = 50.0 ## pixels
@export var shake_calculation: ShakeCalculation = ShakeCalculation.TRAUMA_SQUARED
@export var recovery_factor: float = 1.0
@export var target: Node

var noise_seed: int = 0
var trauma: float = 0.0 # 0.0 to 1.0
var time: float = 0.0
var _calc_shake: Callable = func(): return trauma

func _enter_tree() -> void:
	get_parent().set_meta(META_NAME, self)
	
func _exit_tree() -> void:
	get_parent().remove_meta(META_NAME)

func _ready() -> void:
	if (target == null):
		target = get_parent()

	if (shake_calculation == ShakeCalculation.TRAUMA_SQUARED):
		_calc_shake = _calc_shake_squared
	elif (shake_calculation == ShakeCalculation.TRAUMA_CUBED):
		_calc_shake = _calc_shake_cubed

func set_noise_seed(value: int) -> void:
	noise_seed = value

func apply_trauma(amount: float) -> void:
	trauma = clamp(trauma + amount, 0, 1)
	
func _recover_from_trauma(delta: float) -> void:
	trauma = clamp(trauma - delta * recovery_factor, 0, 1)

func _physics_process(delta: float) -> void:
	time += delta
	var shake: float = _calc_shake.call()
	target.global_rotation_degrees = max_angle * shake * _get_noise(noise_seed+0) # TODO: make owner.angle_offset
	target.offset.x = max_offset_x * shake * _get_noise(noise_seed+1)
	target.offset.y = max_offset_y * shake * _get_noise(noise_seed+2)
	_recover_from_trauma(delta)

func _calc_shake_squared() -> float:
	return trauma * trauma

func _calc_shake_cubed() -> float:
	return trauma * trauma * trauma

func _get_noise(seed: int) -> float:
	noise.seed = seed
	return noise.get_noise_1d(time * noise_speed)
	
# TODO: remove, for debugging
"""
func _unhandled_key_input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("ui_up")):
		apply_trauma(1.0)
	elif (Input.is_action_just_pressed("ui_down")):
		apply_trauma(0.75)
	elif (Input.is_action_just_pressed("ui_left")):
		apply_trauma(0.5)
	elif (Input.is_action_just_pressed("ui_right")):
		apply_trauma(0.25)
	elif (Input.is_action_just_pressed("ui_accept")):
		apply_trauma(0.1)
"""
