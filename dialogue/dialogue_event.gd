class_name DialogueEvent extends Resource

signal finished

# TODO: support "complex" conditionals

@export var start_dialogue_node: DialogueNode
@export var edges: Dictionary

var current_dialogue_node: DialogueNode

func _init() -> void:
	current_dialogue_node = start_dialogue_node

func set_start(dialogue_node: DialogueNode) -> void:
	current_dialogue_node = dialogue_node

func add_edge(
		from_node: DialogueNode,
		to_node: DialogueNode,
		conditional: DialogueConditional = null
		) -> void:
	if (edges.has(from_node)):
		edges[from_node].push_back(DialogueTransition.new(to_node, conditional))
	else:
		edges[from_node] = [DialogueTransition.new(to_node, conditional)]

func next_dialogue_node(node: Node) -> DialogueNode:
	if (current_dialogue_node == null || !edges.has(current_dialogue_node)):
		current_dialogue_node = null
		finished.emit()
		return null

	for transition: DialogueTransition in edges[current_dialogue_node]:
		if (transition.conditional == null || await transition.conditional.execute(node)):
			current_dialogue_node = transition.dialogue_node
			return current_dialogue_node

	current_dialogue_node = null
	finished.emit()
	return null

func get_current_dialogue_node() -> DialogueNode:
	return current_dialogue_node
