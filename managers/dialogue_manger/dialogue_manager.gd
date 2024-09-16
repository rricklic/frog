class_name DialogueManager extends Node

@export var dialogue_box_scene: PackedScene
@export var dialogue_box_cache_size: int = 8

const GROUP: String = "DialogueManager"

var _dialogue_box_cache: Array[DialogueBox]

@onready var canvas_layer: CanvasLayer = $CanvasLayer

func _ready() -> void:
	add_to_group(GROUP)
	for i in range(0, dialogue_box_cache_size):
		var dialogue_box: DialogueBox = dialogue_box_scene.instantiate()
		dialogue_box.finished.connect(_on_dialogue_box_finished.bind(dialogue_box))
		_disable_dialogue_box(dialogue_box)
		_dialogue_box_cache.push_back(dialogue_box)
		add_child.call(dialogue_box)

func _disable_dialogue_box(dialogue_box: DialogueBox) -> void:
	dialogue_box.hide()
	dialogue_box.process_mode = Node.PROCESS_MODE_DISABLED
	
func _enable_dialogue_box(dialogue_box: DialogueBox) -> void:
	dialogue_box.show()
	dialogue_box.process_mode = Node.PROCESS_MODE_INHERIT

func _on_dialogue_box_finished(dialogue_box: DialogueBox) -> void:
	_disable_dialogue_box(dialogue_box)
	_dialogue_box_cache.push_back(dialogue_box)

func display(dialogue: Dialogue) -> void:
	var dialogue_box: DialogueBox = _dialogue_box_cache.pop_back()
	dialogue_box.display(dialogue)
	_enable_dialogue_box(dialogue_box)

# TODO: track that some event happened
# var _backboard: Dictionary ## DialogueEvent -> Variant
#func add_event(event: DialogueEvents.Type, value: Variant) -> void:
#	_backboard[event] = value
#func get_event(event: DialogueEvents.Type) -> Variant:
#   return _backboard.get(event, null)
