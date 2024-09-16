class_name DialogueActionItem extends DialogueAction

enum Direction {
	GIVE_TO_PLAYER,
	TAKE_FROM_PLAYER
}

@export var item: String
@export var direction: Direction

func _init(item_arg: String, direction_arg: Direction) -> void:
	item = item_arg
	direction = direction_arg

func execute(node: Node) -> void:
	var interface: PlayerManagerInterface = ManagerInterface.get_interface(node.get_tree(), PlayerManagerInterface.GROUP)
	if (interface == null):
		return
	match direction:
		Direction.GIVE_TO_PLAYER: interface.add_item(item)
		Direction.TAKE_FROM_PLAYER: interface.remove_item(item)
