class_name GridMovementComponent extends Node

@export_category("Input")
@export var up_action: String = "ui_up"
@export var down_action: String = "ui_down"
@export var left_action: String = "ui_left"
@export var right_action: String = "ui_right"
@export var input_buffer_duration: float = 0.05
@export_category("Movement")
@export var speed: float = 500.0
@export_category("Grid")
@export var grid_size: Vector2 = Vector2(64, 64)

var _is_moving: bool = false
var _tween_duration_x: float = grid_size.x / speed
var _tween_duration_y: float = grid_size.y / speed
var _direction: Vector2 = Vector2.ZERO
var _is_favor_x_dir: bool = true

@onready var _timer: Timer = $Timer

func _ready() -> void:
	_timer.timeout.connect(_on_timer_timeout)
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	if (_is_moving || !_direction):
		return

	var tween: Tween = create_tween()
	var target_position: Vector2 = owner.global_position + _direction * grid_size
	tween.set_parallel(true)
	tween.tween_property(owner, "global_position:x", target_position.x, _tween_duration_x)
	tween.tween_property(owner, "global_position:y", target_position.y, _tween_duration_y)
	tween.finished.connect(_on_tween_finished)
	_is_moving =  true
	_direction = Vector2.ZERO
	_is_favor_x_dir = !_is_favor_x_dir
	_timer.stop()
	set_physics_process(false)

func _on_tween_finished() -> void:
	_is_moving = false

func _unhandled_input(event: InputEvent) -> void:
	if (_is_favor_x_dir):
		if (Input.is_action_just_pressed(left_action)):
			_direction = Vector2.LEFT
		elif (Input.is_action_just_pressed(right_action)):
			_direction = Vector2.RIGHT
		elif (Input.is_action_just_pressed(up_action)):
			_direction = Vector2.UP
		elif (Input.is_action_just_pressed(down_action)):
			_direction = Vector2.DOWN
	else:
		if (Input.is_action_just_pressed(up_action)):
			_direction = Vector2.UP
		elif (Input.is_action_just_pressed(down_action)):
			_direction = Vector2.DOWN
		elif (Input.is_action_just_pressed(left_action)):
			_direction = Vector2.LEFT
		elif (Input.is_action_just_pressed(right_action)):
			_direction = Vector2.RIGHT
		
	if (_direction):
		_timer.start(input_buffer_duration)
		set_physics_process(true)

func _on_timer_timeout() -> void:
	_direction = Vector2.ZERO
