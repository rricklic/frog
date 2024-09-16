class_name Level extends Node2D

@export var setup_fall_distance: float = 1000
@export var music: AudioStream

@onready var deadzone: Area2D = $Deadzone
@onready var ball_spawn_point: Marker2D = $BallSpawnPoint
@onready var paddle: Paddle = $Paddle
@onready var bricks: Node = $Bricks
@onready var ball: Ball = $Ball
@onready var audio_manager_interface: AudioManagerInterface = $AudioManagerInterface

# TODO: slow motion on last brick

func _ready() -> void:
	deadzone.body_entered.connect(_on_deadzone_body_entered)
	ball.hit.connect(_on_ball_hit)
	_setup()

# TODO: squash/stretch when falling in
func _setup() -> void:
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EaseType.EASE_OUT)
	tween.set_trans(Tween.TransitionType.TRANS_BACK)
	
	paddle.global_position.y -= setup_fall_distance;
	paddle.rotation_degrees = randf_range(-15, 15)
	var delay: float = randf_range(0, 0.25)
	tween.tween_property(paddle, "global_position:y", paddle.global_position.y + setup_fall_distance, 1.0) \
			.set_delay(delay)
	tween.tween_property(paddle, "rotation_degrees", 0, 1.0) \
			.set_delay(delay)

	for brick in bricks.get_children():
		brick.disable_collision()
		brick.global_position.y -= setup_fall_distance
		brick.rotation_degrees = randf_range(-15, 15)
		delay = randf_range(0, 0.25)
		tween.tween_property(brick, "global_position:y", brick.global_position.y + setup_fall_distance, 1.0) \
				.set_delay(delay)
		tween.tween_property(brick, "rotation_degrees", 0, 1.0) \
				.set_delay(delay)

	await tween.finished

	for brick in bricks.get_children():
		brick.enable_collision()
	_spawn_ball()
	
	audio_manager_interface.play_music(music)

func _on_deadzone_body_entered(body: Node2D) -> void:
	if (body == ball):
		_spawn_ball()
		# TODO: decrease number of balls left

func _on_ball_hit() -> void:
	for brick in bricks.get_children():
		brick.wobble()

func _spawn_ball() -> void:
	ball.init()
	ball.global_position = ball_spawn_point.global_position
	
func _unhandled_key_input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("ui_up")):
		_setup()
