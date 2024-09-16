class_name Wall extends StaticBody2D

@export var color: Color = Color.WHITE

@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var polygon_2d: Polygon2D = $CollisionPolygon2D/Polygon2D

func _ready() -> void:
	polygon_2d.polygon = collision_polygon_2d.polygon

func handle_hit(collision: KinematicCollision2D) -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EaseType.EASE_OUT)
	tween.set_trans(Tween.TransitionType.TRANS_ELASTIC)
	tween.tween_property(polygon_2d, "scale", Vector2.ONE, 0.75).from(Vector2(0.9, 0.9))
