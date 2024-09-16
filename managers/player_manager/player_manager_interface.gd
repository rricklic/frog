class_name PlayerManagerInterface extends ManagerInterface

const GROUP: String = "PlayerManagerInterface"

func _ready() -> void:
	add_to_group(GROUP)

func has_item(item: String) -> bool:
	var player_manager: PlayerManager = _get_or_create_manager()
	return player_manager.has_item(item)
	
func add_item(item: String):
	var player_manager: PlayerManager = _get_or_create_manager()
	player_manager.add_item(item)
	
func remove_item(item: String):
	var player_manager: PlayerManager = _get_or_create_manager()
	player_manager.remove_item(item)

func disable_movement() -> void:
	var player_manager: PlayerManager = _get_or_create_manager()
	player_manager.disable_movement()
	
func enable_movement() -> void:
	var player_manager: PlayerManager = _get_or_create_manager()
	player_manager.enable_movement()
