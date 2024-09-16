class_name Brick extends RigidBody2D

var hit: bool = false

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var smoke_particles: GPUParticles2D = $SmokeParticles

func disable_collision() -> void:
	collision_shape_2d.disabled = true
	
func enable_collision() -> void:
	collision_shape_2d.disabled = false

func handle_hit(collision: KinematicCollision2D) -> void:
	hit = true

	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(polygon_2d, "scale", Vector2.ZERO, 1.0)
	tween.tween_property(polygon_2d, "color:a", 0, 1.0).from(0.5)
	
	# TODO: apply force so brick falls off screen
	# TODO: shatter
	
	disable_collision()
	
	smoke_particles.restart()
	smoke_particles.global_position = collision.get_position()
	smoke_particles.rotation = collision.get_normal().angle()
	smoke_particles.emitting = true

func wobble() -> void:
	if (hit):
		return
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EaseType.EASE_OUT)
	tween.set_trans(Tween.TransitionType.TRANS_ELASTIC)
	tween.tween_property(polygon_2d, "scale", Vector2.ONE, 1.0).from(Vector2(0.8, 0.8))
