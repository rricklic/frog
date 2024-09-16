class_name UIFocusSlideComponent extends UIComponent

@export var offset: Vector2
@export var duration: float = 0.5
@export var trans_type: Tween.TransitionType = Tween.TransitionType.TRANS_SPRING
@export var ease_type: Tween.EaseType = Tween.EaseType.EASE_OUT

var original_position: Vector2

func _setup() -> void:
	original_position = target.position
	UIUtil.center_pivot_offset(target)
	target.mouse_entered.connect(_on_focus_entered)
	target.mouse_exited.connect(_on_focus_exited)
	target.focus_entered.connect(_on_focus_entered)
	target.focus_exited.connect(_on_focus_exited)

func _create_tween() -> Tween:
	var tween: Tween = create_tween()
	tween.set_trans(trans_type)
	tween.set_ease(ease_type)
	return tween

func _on_focus_entered() -> void:
	_create_tween().tween_property(target, "global_position", original_position + offset, duration)
	
func _on_focus_exited() -> void:
	_create_tween().tween_property(target, "global_position", original_position, duration)
