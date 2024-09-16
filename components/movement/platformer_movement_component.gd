class_name PlatformerMovementComponent extends Node

################################################################################
# Description: 
# Making a Jump You Can Actually Use - https://www.youtube.com/watch?v=IOe1aGY6hXA&t=25s
# Building a Better Jump GDC - https://www.youtube.com/watch?v=hG9SzQxaCm8&t=801s
################################################################################

# TODO: multiple jumps
# TODO: dash
# TODO: wall jump
# TODO: jump buffer
# TODO: coyote time
# TODO: jump movement vs walk movement
# TODO: walk vs run
# TODO: movement multiplier
# TODO: max fall spee
# TODO: variable jump height

@export_category("Input")
@export var left_action: String = "ui_left"
@export var right_action: String = "ui_right"
@export var jump_action: String = "ui_accept"
@export_category("Movement")
@export var max_speed_x: float = 500.0 ## pixels per second
@export var acceleration_ground: float = 1000.0
@export var acceleration_air: float = 1000.0
@export var acceleration_multiplier: float = 1.0
@export var max_speed_x_multiplier: float = 1.0
@export_category("Jump Parameters")
@export var jump_height: float = 300.0
@export var jump_time_peak: float = 0.5
@export var jump_time_fall: float = 0.4
@export var gravity_scale: float = 1.0
@export_category("Friction")
@export var friction_ground: float = 1000.0
@export var friction_air: float = 1000.0
@export var friction_multiplier: float = 1.0

var _jump_velocity: float = (2.0 * jump_height) / jump_time_peak * -1.0
var _jump_gravity: float = -(2.0 * jump_height) / (jump_time_peak * jump_time_peak) * -1.0
var _fall_gravity: float = -(2.0 * jump_height) / (jump_time_fall * jump_time_fall) * -1.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var direction_x: float = Input.get_axis(left_action, right_action)
	
	_handle_gravity(delta)
	_handle_jump()
	_handle_movement(delta)
	owner.move_and_slide()

func _handle_gravity(delta: float) -> void:
	if (!owner.is_on_floor()): # && coyote_time_timer.time_left <= 0.0 # To walk off floor without falling
		var gravity: float = _jump_gravity if (owner.velocity.y < 0.0) else _fall_gravity
		owner.velocity.y += gravity * gravity_scale * delta

func _handle_jump() -> void:
	if (owner.is_on_floor() && Input.is_action_just_pressed(jump_action)):
		owner.velocity.y = _jump_velocity

func _handle_movement(delta: float) -> void:
	var direction: float = Input.get_axis(left_action, right_action)
	if direction:
		var acceleration: float = acceleration_ground if owner.is_on_floor() else acceleration_air
		owner.velocity.x = move_toward(owner.velocity.x, direction * max_speed_x, acceleration * acceleration_multiplier * delta)
	else:
		var friction: float = friction_ground if owner.is_on_floor() else friction_air
		owner.velocity.x = move_toward(owner.velocity.x, 0, friction * friction_multiplier * delta)

# Called when an input event hasn't been consumed by _input() or any GUI Control
# item. It is called after _shortcut_input() but before _unhandled_input(). The
# input event propagates up through the node tree until a node consumes it.
func _unhandled_key_input(event: InputEvent) -> void:
	pass
