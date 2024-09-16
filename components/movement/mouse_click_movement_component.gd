class_name MouseClickMovementComponent extends Node
# TODO: forward vs back speed

@export_category("Movement")
@export var speed: float = 400.0 ## pixels per second
@export var acceleration: float = 1000.0
@export var acceleration_multiplier: float = 1.0
#@export var rotation_speed: float = 90.0 ## degrees per second
#@export var acceleration_rotation: float = 500.0
#@export var acceleration_rotation_multiplier: float = 1.0
@export_category("Friction")
@export var friction: float = 200.0
@export var friction_multiplier: float = 1.0
#@export var friction_rotation: float = 200.0
#@export var friction_rotation_multiplier: float = 1.0

var _mouse_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	_mouse_position = owner.global_position

#func _rotate_to(target_position: Vector2, delta: float) -> void:
#	var direction: Vector2 = (target_position - owner.global_position).normalized()
#	var angle_to = owner.transform.x.angle_to(direction)
#	# var rotaion_factor: float = velocity / speed # TODO
#	var rotaion_factor: float = 1.0 # the percentage of full speed; rotation slows are velocity slows
#	owner.rotate(sign(angle_to) * min(delta * rotation_speed * rotaion_factor * delta, abs(angle_to)))
	
func _physics_process(delta: float) -> void:
	if (_mouse_position.distance_squared_to(owner.global_position) < 10):
		owner.velocity = Vector2.ZERO
		return
	
	#if (owner.velocity):
	#	_rotate_to(_mouse_position, delta)
	
	#var move_direction: Vector2 = Vector2.RIGHT.rotated(owner.rotation)
	#owner.velocity = owner.velocity.move_toward(move_direction * _mouse_position * speed, acceleration * acceleration_multiplier * delta)
	var direction: Vector2 = (_mouse_position - owner.global_position).normalized()
	owner.velocity = owner.velocity.move_toward(direction * speed, acceleration * acceleration_multiplier * delta)

	owner.move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_mouse_position = event.position
