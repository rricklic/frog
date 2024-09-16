class_name PlayerManager extends Manager

const GROUP: String = "PlayerManager"

# TODO: handle multiple players

func _ready() -> void:
	add_to_group(GROUP)

func _get_player() -> Player:
	return get_tree().get_first_node_in_group(Player.GROUP)

func has_item(item: String) -> bool:
	var player: Player = _get_player()
	return player != null && player.has_item(item)
	
func add_item(item: String) -> void:
	var player: Player = _get_player()
	if (player == null):
		return
	player.add_item(item)
	
func remove_item(item: String) -> void:
	var player: Player = _get_player()
	if (player == null):
		return
	player.remove_item(item)

func disable_movement() -> void:
	var player: Player = _get_player()
	if (player == null):
		return
	player.disable_movement()
	
func enable_movement() -> void:
	var player: Player = _get_player()
	if (player == null):
		return
	player.enable_movement()
