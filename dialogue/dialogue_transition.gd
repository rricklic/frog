class_name DialogueTransition extends Resource

@export var dialogue_node: DialogueNode
@export var conditional: DialogueConditional

func _init(dialogue_node_arg: DialogueNode = null, conditional_arg: DialogueConditional = null):
	dialogue_node = dialogue_node_arg
	conditional = conditional_arg
