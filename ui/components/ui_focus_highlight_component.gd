class_name UIFocusHighlightComponent extends UIComponent

@export var color: Color = Color.RED
@export var duration: float = 0.1
@export var trans_type: Tween.TransitionType = Tween.TransitionType.TRANS_QUAD
@export var ease_type: Tween.EaseType = Tween.EaseType.EASE_IN_OUT

var default: Color

func _setup() -> void:
	default = target.self_modulate
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
	_create_tween().tween_property(target, "self_modulate", color, duration)

func _on_focus_exited() -> void:
	_create_tween().tween_property(target, "self_modulate", default, duration)
