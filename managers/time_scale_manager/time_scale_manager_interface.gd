class_name TimeScaleManagerInterface extends ManagerInterface

func set_time_scale(time_scale: float, tween_duration) -> void:
	var manager: TimeScaleManager = _get_or_create_manager()
	manager.set_time_scale(time_scale, tween_duration)

func apply_hit_stop(duration: float) -> void:
	var manager: TimeScaleManager = _get_or_create_manager()
	manager.apply_hit_stop(duration)
