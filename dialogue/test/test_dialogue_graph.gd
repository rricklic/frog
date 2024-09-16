class_name TestDialogueGraph extends Node

var dialogue_event: DialogueEvent = DialogueEvent.new()

@onready var player: Player = $Player
@onready var dialogue_manager_interface: DialogueManagerInterface = $DialogueManagerInterface

func _ready() -> void:
	var node_0: DialogueNode = DialogueNode.new("Testing")
	var node_1: DialogueNode = DialogueNode.new("Come back when you have proven your worth!")
	var node_2: DialogueNode = DialogueNode.new("I see that you have the ball. You are indeed quite brave. I shall reward you for your accomplishment.")
	var node_3: DialogueNode = DialogueNode.new("Here, have a coin.")
	var node_3a: DialogueNode = DialogueActionItem.new("Coin", DialogueActionItem.Direction.GIVE_TO_PLAYER)
	var node_4: DialogueNode = DialogueNode.new("Do you like cheese?", ["Yes", "No"])
	var node_5: DialogueNode = DialogueNode.new("That's great!!!")
	dialogue_event.set_start(node_0)
	dialogue_event.add_edge(node_0, node_2, DialogueConditionalItem.new("Ball"))
	dialogue_event.add_edge(node_0, node_1)
	dialogue_event.add_edge(node_2, node_3)
	dialogue_event.add_edge(node_3, node_3a)
	dialogue_event.add_edge(node_3a, node_4)
	dialogue_event.add_edge(node_4, node_5, DialogueConditionalChoice.new("Yes"))
	dialogue_event.add_edge(node_4, node_4, DialogueConditionalChoice.new("No"))	
	
	test()

func test() -> void:
	player.add_item("Ball")
	
	dialogue_manager_interface.handle_dialogue_event(dialogue_event)
	await dialogue_event.finished # TODO: make await optional (e.g.: dialogue_event.is_wait)
	
	print(player.has_item("Coin"))
