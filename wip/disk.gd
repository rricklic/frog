class_name Disk extends Sprite2D

################################################################################
# Description: 
################################################################################

#var disk_offset: Vector2 = Vector2.ZERO

################################################################################
# CONSTRUCTOR / DESTRUCTOR
################################################################################
@onready var shake_component: ShakeComponent = $ShakeComponent

func _ready() -> void:
	# global_position = ScreenUtil.get_viewport_size(self) / 2.0
	# float_up()
	
	var random: int = randi()
	print(random)
	shake_component.set_noise_seed(random)
	shake_component.apply_trauma(1.0)

func float_up() -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position + Vector2(0, 20), 1.0) \
			.set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(float_down)
	
func float_down() -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position + Vector2(0, -20), 1.0) \
			.set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(float_up)
