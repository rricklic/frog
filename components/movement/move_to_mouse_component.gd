class_name MoveToMouseComponent extends Node

enum MoveDirection {
	MOVE_XY,
	MOVE_X,
	MOVE_Y
}

"""
@export_category("Movement")
@export var max_speed: float = 2000.0 ## pixels per second
@export var acceleration: float = 5000.0
@export var acceleration_multiplier: float = 1.0
@export_category("Friction")
@export var friction: float = 5000.0
@export var friction_multiplier: float = 1.0
@export_category("Direction")
"""
@export var move_direction: MoveDirection = MoveDirection.MOVE_XY

var _mouse_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	_mouse_position = owner.global_position

func _physics_process(delta: float) -> void:
	if (move_direction == MoveDirection.MOVE_XY):
		owner.global_position = _mouse_position
	elif (move_direction == MoveDirection.MOVE_X):
		owner.global_position.x = _mouse_position.x
	elif (move_direction == MoveDirection.MOVE_Y):
		owner.global_position.y = _mouse_position.y
	
	
	"""
	var distance: float
	if (move_direction == MoveDirection.MOVE_XY):
		distance = _mouse_position.distance_squared_to(owner.global_position)
	elif (move_direction == MoveDirection.MOVE_X):
		distance = _mouse_position.x - owner.global_position.x
	elif (move_direction == MoveDirection.MOVE_Y):
		distance = _mouse_position.y - owner.global_position.y
	
	if (abs(distance) < 10):
		owner.velocity = Vector2.ZERO
		return
	
	var direction: Vector2 = (_mouse_position - owner.global_position).normalized()
	if (move_direction == MoveDirection.MOVE_XY):
		owner.velocity = owner.velocity.move_toward(direction * max_speed, acceleration * acceleration_multiplier * delta)
	elif (move_direction == MoveDirection.MOVE_X):
		owner.velocity.x = owner.velocity.move_toward(direction * max_speed, acceleration * acceleration_multiplier * delta).x
	elif (move_direction == MoveDirection.MOVE_Y):
		owner.velocity.x = owner.velocity.move_toward(direction * max_speed, acceleration * acceleration_multiplier * delta).y
	"""

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_mouse_position = event.position
