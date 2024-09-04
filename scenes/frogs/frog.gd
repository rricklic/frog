class_name Frog extends CharacterBody2D

@export var jump_audio_stream: AudioStream

# NOTE: To get squash corretly, must setup offset.y to be on bottom of the sprite
# https://www.youtube.com/watch?v=iJx6uKqufJo

var jump_height: float = 0
var jump_velocity: float = 0
var gravity: float = 250

var hop_speed: float = 125
var num_hops: int = 0
var hop_velocity: Vector2 = Vector2.ZERO

var can_hop = true
var is_jumping = true

@onready var frog_sprite: Sprite2D = $FrogSprite
@onready var audio_manager_interface: AudioManagerInterface = $AudioManagerInterface
@onready var original_offset_y: float = frog_sprite.offset.y

func _ready() -> void:
	set_physics_process(false)
	await get_tree().create_timer(randf_range(0.5, 3)).timeout
	set_physics_process(true)
	_init_hops()

func stop_jumping() -> void:
	is_jumping = false
	
func start_jumping() -> void:
	is_jumping = true
	await get_tree().create_timer(randf_range(0.15, 0.4)).timeout
	can_hop = is_jumping

func _physics_process(delta: float) -> void:
	_handle_hop(delta)
	move_and_slide()
	frog_sprite.scale.x = move_toward(frog_sprite.scale.x, 1, 1 * delta)
	frog_sprite.scale.y = move_toward(frog_sprite.scale.y, 1, 1 * delta)

func _is_on_ground() -> bool:
	return jump_height == 0

func _init_hops() -> void:
	if (num_hops != 0):
		return
	num_hops = randi_range(2, 6)
	hop_velocity = Vector2(randi_range(-20, 20), randi_range(-20, 20))
	hop_speed = randi_range(100, 150)

func _hop() -> void:
	if (num_hops == 0 || !_is_on_ground() || !is_jumping):
		return
	audio_manager_interface.play_audio(jump_audio_stream, randf_range(0.85, 1.05))
	jump_velocity = hop_speed
	velocity = hop_velocity
	frog_sprite.scale = Vector2(0.7, 1.3)
	num_hops = num_hops - 1

func _handle_gravity(delta: float) -> void:
	if (_is_on_ground() && jump_velocity == 0.0):
		return
	jump_height -= jump_velocity * delta
	jump_velocity -= gravity * delta
	frog_sprite.offset.y = original_offset_y + jump_height

func _land() -> void:
	if (jump_height < 0):
		return
	can_hop = false
	velocity = Vector2.ZERO
	jump_height = 0
	frog_sprite.offset.y = original_offset_y
	frog_sprite.scale = Vector2(1.3, 0.7)
	if (num_hops == 0):
		await get_tree().create_timer(randf_range(1, 3)).timeout
		_init_hops()
	else:
		await get_tree().create_timer(randf_range(0.15, 0.4)).timeout
	can_hop = is_jumping
	
func _handle_hop(delta: float) -> void:
	if (!can_hop):
		return

	_hop()
	_handle_gravity(delta)
	_land()
	
