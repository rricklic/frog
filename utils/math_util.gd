class_name MathUtil extends RefCounted

# TODO: move to component/movement
static func rotate_to(
		source: Node2D,
		target: Node2D,
		rotation_speed: float,
		delta: float
		) -> void:
	var direction: Vector2 = target.global_position - source.global_position
	var angle_to = source.transform.x.angle_to(direction)
	source.rotate(sign(angle_to) * min(delta * rotation_speed, abs(angle_to)))
