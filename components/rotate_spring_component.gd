class_name RotateSpringComponent extends Component

# Damped occilator for rotation

@export_range(0, 1000) var spring: float = 800
@export_range(0, 40) var damp: float = 10
@export_range(0, 100) var max_velocity: float = 20
@export_range(0.5, 2) var scale: float = 1.0
@export var multiplier: float = 1.0

var velocity: float = 0
var displacement: float = 0

var original_rotation: float
var original_scale: Vector2
var original_position: Vector2

func _setup() -> void: 
	original_rotation = target.rotation
	original_scale = target.scale
	original_position = target.position

func trigger() -> void:
	var modifier: int = -1 if randi_range(0, 1) == 0 else 1 
	velocity = max_velocity * modifier
	#if (scale != 1.0):
	#	var tween: Tween = create_tween() 
	#	tween.tween_property(target, "scale", original_scale * scale, 0.1).set_trans(Tween.TRANS_QUAD)
	#	tween.tween_property(target, "scale", original_scale, 0.15).set_trans(Tween.TRANS_QUAD)

func _process(delta: float) -> void:
	var force: float = -spring * displacement - damp * velocity
	velocity += force * delta
	displacement += velocity * delta
	
	target.rotation = original_rotation + displacement

	#target.position.y = original_position.y + (displacement * multiplier)
	#target.position.x = original_position.x + (displacement * multiplier)
	
	#target.scale = original_scale + (original_scale * (displacement * multiplier))
