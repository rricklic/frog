class_name DialogueArea extends Area2D

enum Trigger {
	ON_ENTER,
	BUTTON_PRESS,
	MOUSE_CLICK
}

# TODO: stop player movement when dialogue in progress
# TODO: automatically hide dialoge when in area
# TODO: don't allow dialogue to re-trigger if visible

@export var trigger: Trigger = Trigger.ON_ENTER
@export var dialogue_event: DialogueEvent
@export var is_disable_player: bool = true
@export var input_button: String = "ui_accept"

var is_in_area: bool = false

@onready var marker_2d: Marker2D = $Marker2D
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
	if (Input.is_action_just_pressed(input_button) && is_in_area):
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
	#if (is_disable_player):
	#	get_tree().get_first_node_in_group("Player").disable_movement() # TODO: use PlayerInterface

	# TODO: pass marker_2d OR marker_2d.global_position OR self
	dialogue_manager_interface.handle_dialogue_event(dialogue_event) 
	
	# TODO:
	#var finished_signal: Signal = dialogue_manager_interface.display(dialogue, marker_2d.global_position)
	#finished_signal.connect(_on_dialogue_box_finished.bind(finished_signal))
	
func _on_dialogue_box_finished(finished_signal: Signal) -> void:
	print("DIALOGUE BOX FINISHED")
	if (is_disable_player):
		get_tree().get_first_node_in_group("Player").enable_movement() # TODO: use PlayerInterface
	finished_signal.disconnect(_on_dialogue_box_finished)
