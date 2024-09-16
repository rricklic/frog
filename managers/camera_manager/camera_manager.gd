class_name CameraManager extends Manager

const GROUP: String = "CameraManager"

func _ready() -> void:
	add_to_group(GROUP)

func apply_trauma(trauma: float) -> void:
	var camera: Camera2D = get_viewport().get_camera_2d()
	if (camera == null):
		return

	var shake_component: ShakeComponent = camera.get_meta(ShakeComponent.META_NAME)
	if (shake_component):
		shake_component.apply_trauma(trauma)

# TODO: add and test below functionality
func zoom(amount: Vector2, tween_duration: float) -> void:
	var camera: Camera2D = get_viewport().get_camera_2d()
	if (camera == null):
		return
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(camera, "zoom", amount, tween_duration)

# TODO: add/remove/switch cameras (with transition)

# TODO: add/remove targets (with transition)
