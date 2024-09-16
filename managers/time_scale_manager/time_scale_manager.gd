class_name TimeScaleManager extends Manager

const GROUP: StringName = "TimeScaleManager"

func _ready() -> void:
	add_to_group(GROUP)

func set_time_scale(time_scale: float, tween_duration) -> void:
	time_scale = max(time_scale, 0.05)
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(Engine, "time_scale", time_scale, tween_duration)

func apply_hit_stop(duration: float) -> void:
	Engine.time_scale = 0
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1
