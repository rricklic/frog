class_name DialogueArea extends Area2D

enum Trigger {
	ON_ENTER,
	BUTTON_PRESS,
	MOUSE_CLICK
}

# TODO: stop player movement when dialogue in progress

@export var trigger: Trigger = Trigger.ON_ENTER
@export var dialogue: Dialogue

var is_in_area: bool = false

@onready var dialogue_manager_interface: DialogueManagerInterface = $DialogueManagerInterface

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	area_exited.connect(_on_area_exited)
	body_exited.connect(_on_body_exited)
	set_process_unhandled_key_input(trigger == Trigger.BUTTON_PRESS)
	if (trigger == Trigger.MOUSE_CLICK):
		input_event.connect(_on_area_input_event)

func _unhandled_key_input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("ui_accept") && is_in_area): # TODO: input button
		_trigger()

func _on_area_input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton && event.is_pressed()):
		_trigger()

func _on_area_entered(area: Area2D) -> void:
	if (trigger == Trigger.ON_ENTER): # TODO: ensure only certain areas
		_trigger()
	is_in_area = true

func _on_area_exited(area: Area2D) -> void:
	# TODO: ensure only certain areas
	is_in_area = false
	
func _on_body_entered(body: Node2D) -> void:
	if (trigger == Trigger.ON_ENTER): # TODO: ensure only certain areas
		_trigger()
	is_in_area = true

func _on_body_exited(body: Node2D) -> void:
	# TODO: ensure only certain areas
	is_in_area = false

func _trigger() -> void:
	dialogue_manager_interface.display(dialogue)
