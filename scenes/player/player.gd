class_name Player extends CharacterBody2D

const GROUP = "Player"

var inventory: Dictionary = {} # TODO: properly model, use Resources

@onready var top_down_movement_component: TopDownMovementComponent = $TopDownMovementComponent

func _ready() -> void:
	add_to_group(GROUP)

func disable_movement() -> void:
	top_down_movement_component.set_physics_process(false)
	
func enable_movement() -> void:
	top_down_movement_component.set_physics_process(true)

func add_item(item: String) -> void:
	print("add_item=" + item)
	inventory[item] = 1
	
func remove_item(item: String) -> void:
	print("remove_item=" + item)
	inventory.erase(item)
	
func has_item(item: String) -> bool:
	print("has_item=" + str(inventory.has(item)))
	return inventory.has(item)
