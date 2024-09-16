class_name ForceUtil extends Object

static func knockback(
		position: Vector2,
		hit_position: Vector2,
		weight: float,
		speed: float
		) -> Vector2:
	return (position - hit_position).normalized() * weight * speed
