class_name Ball extends CharacterBody2D

signal hit

@export var max_speed: float = 800
@export var min_speed: float = 200
@export var bounce: AudioStream
@export var bounce_2: AudioStream
@export var bounce_3: AudioStream

var color: Color
var pitch: float = 1.0

@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var audio_manager_interface: AudioManagerInterface = $AudioManagerInterface
@onready var camera_manager_interface: CameraManagerInterface = $CameraManagerInterface
@onready var trail_component: TrailComponent = $TrailComponent
@onready var area_2d: Area2D = $Area2D
@onready var time_scale_manager_interface: TimeScaleManagerInterface = $TimeScaleManagerInterface

func _ready() -> void:
	velocity = Vector2.ZERO
	color = polygon_2d.color
	
	# TODO: slow motion on last brick
	#area_2d.body_entered.connect(_on_area_body_entered)
	#area_2d.body_exited.connect(_on_area_body_exited)

func init() -> void:
	velocity = _random_velocity()
	polygon_2d.look_at(velocity)
	pitch = 1.0
	trail_component.clear()
	# TODO: scale based on velocity
	#var scaling: float = clampf(velocity.x / min_speed, 1, 4)
	#polygon_2d.scale = Vector2(1/scaling, scaling)

func _random_velocity() -> Vector2:
	var vel_x: float = randf_range(min_speed, min_speed * 2)
	if (randi_range(0, 1) % 2):
		vel_x *= -1
	return Vector2(vel_x , -randf_range(min_speed, min_speed * 2))

func _process(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if (collision):
		_apply_trauma(collision)
		_adjust_velocity(collision)
		_show_collision(collision)
		_play_sound(collision)
		if (collision.get_collider().has_method("handle_hit")):
			collision.get_collider().handle_hit(collision)
		hit.emit()

func _adjust_velocity(collision: KinematicCollision2D) -> void:
	if (collision.get_collider() is Paddle):
		velocity = velocity.bounce(collision.get_normal())
		var extent: float = (collision.get_position().x - collision.get_collider().global_position.x) / (collision.get_collider().get_size().x / 2)
		velocity.x = (max_speed * extent)
		velocity.y *= 1.05
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
		velocity.y = clamp(velocity.y, -max_speed, max_speed)
	else:
		velocity = velocity.bounce(collision.get_normal())

func _show_collision(collision: KinematicCollision2D) -> void:
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EaseType.EASE_OUT)
	tween.set_trans(Tween.TransitionType.TRANS_ELASTIC)
	tween.tween_property(polygon_2d, "scale", Vector2.ONE, 0.75).from(Vector2(2, 2))
	tween.tween_property(polygon_2d, "color", color, 0.75).from(Color.WHITE)
	polygon_2d.look_at(velocity)
	# TODO: scale based on velocity

func _play_sound(collision: KinematicCollision2D) -> void:
	if (collision.get_collider() is Brick):
		audio_manager_interface.play_audio(bounce_2, pitch)
		pitch += 0.1
		pitch = clampf(pitch, 1.0, 2.0)
	elif (collision.get_collider() is Paddle):
		pitch = 1.0
		audio_manager_interface.play_audio(bounce_3)
	else:
		audio_manager_interface.play_audio(bounce)
		
func _apply_trauma(collision: KinematicCollision2D) -> void:
	camera_manager_interface.apply_trauma(0.25)

func _on_area_body_entered(body: Node2D) -> void:
	if (body is Brick):
		time_scale_manager_interface.set_time_scale(0.2, 0.25)
		
func _on_area_body_exited(body: Node2D) -> void:
	if (body is Brick):
		time_scale_manager_interface.set_time_scale(1, 0.25)
