class_name UISlideComponent extends UIComponent

signal finished

@export var offset: Vector2
@export var duration: float = 0.5
@export var trans_type: Tween.TransitionType = Tween.TransitionType.TRANS_SPRING
@export var ease_type: Tween.EaseType = Tween.EaseType.EASE_OUT

var end_point: Vector2

func _setup() -> void:
	end_point = target.position
	target.position += offset
	UIUtil.center_pivot_offset(target)
	_tween_position()

func _create_tween() -> Tween:
	var tween: Tween = create_tween()
	tween.set_trans(trans_type)
	tween.set_ease(ease_type)
	return tween

func _tween_position() -> void:
	await _create_tween().tween_property(target, "global_position", end_point, duration).finished
	finished.emit()
