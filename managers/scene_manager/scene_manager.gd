class_name SceneManager extends Manager

const GROUP: String = "SceneManager"

var _transition_sprite: Sprite2D = null

func _ready() -> void:
	add_to_group(GROUP)

func _create_screenshot() -> Sprite2D:
	var image = get_viewport().get_texture().get_image()
	var image_texture: ImageTexture = ImageTexture.create_from_image(image)
	var sprite_2d: Sprite2D = Sprite2D.new()
	sprite_2d.texture = image_texture
	sprite_2d.scale = Vector2(2, 2) # TODO: understand the need for this scale...
	return sprite_2d

func switch_scenes(old_scene: Node, new_scene: PackedScene) -> void:
	_transition_sprite = _create_screenshot()
	old_scene.queue_free()
	var scene: Node = new_scene.instantiate() 
	scene.add_child(_transition_sprite)
	get_tree().root.add_child(scene)
	
func delete_transition_sprite() -> void:
	if (!_transition_sprite):
		return
	_transition_sprite.queue_free()
	_transition_sprite = null
