class_name Paddle extends CharacterBody2D

@export var max_scaling: float = 2

@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var _mouse_position: Vector2

# TODO: prevent going past wall boundries
# TODO: particle when hit by ball

func _ready() -> void:
	_mouse_position = global_position

func get_size() -> Vector2:
	return collision_shape_2d.shape.get_rect().size

func _physics_process(delta: float) -> void:
	var dist: float = abs(global_position.x - _mouse_position.x)
	if (dist < 20):
		dist = 0
	var stretch: float = 1 + clamp(dist / 100.0, 0, 1) * max_scaling
	polygon_2d.scale.x = stretch
	polygon_2d.scale.y = 1 / stretch
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_mouse_position = event.position
