class_name OcsillationMovement extends Node

enum Direction {
	VERTICAL,
	HORIZONTAL,
	BOTH
}

@export var target: Node
@export var amplitude: float = 20.0 ## pixels
@export var frequency: float = 1.5
@export var direction: Direction = Direction.VERTICAL

var original_position: Vector2
var time: float = 0.0

func _ready() -> void:
	set_physics_process(false)
	if (target == null):
		target = owner

func ocscillate() -> void:
	original_position = target.global_position
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	time += delta * frequency
	if (direction == Direction.VERTICAL):
		target.global_position = original_position + Vector2(0, sin(time) * amplitude)
	elif (direction == Direction.HORIZONTAL): 
		target.global_position = original_position + Vector2(cos(time) * amplitude, 0)
	elif (direction == Direction.BOTH): 
		target.global_position = original_position + Vector2(cos(time) * amplitude, sin(time) * amplitude)
