class_name TankMovementComponent extends Node

# TODO: forward vs back speed

@export_category("Input")
@export var forward_action: String = "ui_up"
@export var back_action: String = "ui_down"
@export var rotate_left_action: String = "ui_left"
@export var rotate_right_action: String = "ui_right"
@export_category("Movement")
@export var speed: float = 200.0 ## pixels per second
@export var acceleration: float = 1000.0
@export var acceleration_multiplier: float = 1.0
@export var rotation_speed: float = 90.0 ## degrees per second
@export var acceleration_rotation: float = 200.0
@export var acceleration_rotation_multiplier: float = 1.0
@export_category("Friction")
@export var friction: float = 200.0
@export var friction_multiplier: float = 1.0
@export var friction_rotation: float = 200.0
@export var friction_rotation_multiplier: float = 1.0

var _rotation_velocity: float = 0.0

func _physics_process(delta: float) -> void:
	var rotation_direction: float = Input.get_axis(rotate_left_action, rotate_right_action)
	if rotation_direction:
		_rotation_velocity = move_toward(_rotation_velocity, rotation_direction * rotation_speed, acceleration_rotation * acceleration_rotation_multiplier * delta)
		owner.rotation_degrees += _rotation_velocity * delta
	else:
		# TODO: for land vehicles, _rotation_velocity should be zero when owner.velocity is zero
		_rotation_velocity = move_toward(_rotation_velocity, 0, friction_rotation * friction_rotation_multiplier * delta)
		owner.rotation_degrees += _rotation_velocity * delta
	var direction: Vector2 = Vector2(0, Input.get_axis(forward_action, back_action))
	if (direction):
		direction = direction.rotated(owner.rotation)
		owner.velocity = owner.velocity.move_toward(direction * speed, acceleration * acceleration_multiplier * delta)
	else: 
		owner.velocity = owner.velocity.move_toward(Vector2.ZERO, friction * friction_multiplier * delta)
	owner.move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	pass
