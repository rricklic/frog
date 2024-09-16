class_name DialogueManager extends Manager

@export var dialogue_box_scene: PackedScene
@export var dialogue_box_cache_size: int = 8

const GROUP: String = "DialogueManager"

var _dialogue_box_cache: Array[DialogueBox]
var _last_choice: String

@onready var canvas_layer: CanvasLayer = $CanvasLayer

func _ready() -> void:
	add_to_group(GROUP)
	for i in range(0, dialogue_box_cache_size):
		var dialogue_box: DialogueBox = dialogue_box_scene.instantiate()
		dialogue_box.text = ""
		dialogue_box.choices = []
		dialogue_box.finished.connect(_on_dialogue_box_finished.bind(dialogue_box))
		dialogue_box.disable()
		_dialogue_box_cache.push_back(dialogue_box)
		add_child.call(dialogue_box)

func _on_dialogue_box_finished(dialogue_box: DialogueBox) -> void:
	dialogue_box.disable()
	_dialogue_box_cache.push_back(dialogue_box)

func handle_dialogue_event(dialogue_event: DialogueEvent) -> void:
	var dialogue_node: DialogueNode = dialogue_event.get_current_dialogue_node()
	while (dialogue_node):
		if (dialogue_node is DialogueAction):
			_handle_dialogue_action(dialogue_node)
		_last_choice = await _handle_dialogue_node(dialogue_node)
		dialogue_node = await dialogue_event.next_dialogue_node(self)
	# TODO: emit finished?

func _handle_dialogue_node(dialogue_node: DialogueNode) -> String:
	var dialogue_box: DialogueBox = _dialogue_box_cache.pop_back()
	await dialogue_box.display(dialogue_node.text, dialogue_node.choices, Vector2(400, 200)) # TODO: position
	return dialogue_box.get_last_choice()

func _handle_dialogue_action(dialogue_action: DialogueAction) -> void:
	dialogue_action.execute(self)

func get_last_choice() -> String:
	return _last_choice

# TODO: track that some event happened
# var _backboard: Dictionary ## DialogueEvent -> Variant
#func add_event(event: DialogueEvents.Type, value: Variant) -> void:
#	_backboard[event] = value
#func get_event(event: DialogueEvents.Type) -> Variant:
#   return _backboard.get(event, null)
