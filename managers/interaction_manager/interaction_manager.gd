class_name InteractionManager extends Manager

const GROUP: StringName = "InteractionManager"

@export var label_theme: Theme
@export var label_cache_size: int = 4
@export var player_accept_input: Dictionary = {
	"ui_accept" : "Player1",
	"ui_accept_2" : "Player2"
}

var body_areas: Dictionary # interacting_body -> [InteractionArea]
var body_labels: Dictionary # interacting_body -> Label
var body_interacting: Dictionary # interacting_body -> true
var label_cache: Array[Label]

func _ready():
	add_to_group(GROUP)
	_init_label_cache()

func _init_label_cache() -> void:
	for i in range(0, label_cache_size):
		var label: Label = Label.new()
		label.theme = label_theme
		label.hide()
		add_child(label)
		label_cache.push_back(label)

func _register_label(interacting_body: Node2D) -> void:
	if (label_cache.is_empty()):
		return
	body_labels[interacting_body] = label_cache.pop_back()

func _deregister_label(interacting_body: Node2D) -> void:
	if (!body_labels.has(interacting_body)):
		return
	label_cache.push_back(body_labels[interacting_body])
	body_labels[interacting_body].hide()
	body_labels.erase(interacting_body)

func register(area: InteractionArea, interacting_body: Node2D) -> void:
	if (!body_areas.has(interacting_body)):
		body_areas[interacting_body] = []
		_register_label(interacting_body)
	body_areas[interacting_body].push_back(area)
	set_physics_process(true)

func deregister(area: InteractionArea, interacting_body: Node2D) -> void:
	if (body_areas.has(interacting_body)):
		body_areas[interacting_body].erase(area)
		if (body_areas[interacting_body].is_empty()):
			body_areas.erase(interacting_body)
			_deregister_label(interacting_body)
		if (body_areas.is_empty()):
			set_physics_process(false)

func _physics_process(delta: float) -> void:
	for interacting_body: Node2D in body_areas:
		var areas: Array = body_areas[interacting_body]
		areas.sort_custom(_sort_areas.bind(interacting_body))
		_display_label(areas[0], interacting_body)

func _sort_areas(area1: InteractionArea, area2: InteractionArea, interacting_body: Node2D) -> bool:
	var dist_to_area1: float = interacting_body.global_position.distance_squared_to(area1.global_position)
	var dist_to_area2: float = interacting_body.global_position.distance_squared_to(area2.global_position)
	return dist_to_area1 < dist_to_area2

func _display_label(area: InteractionArea, interacting_body: Node2D) -> void:
	var label: Label = body_labels[interacting_body]
	label.text = area.interaction_name
	label.global_position = area.global_position
	label.global_position.x -= label.size.x / 2
	label.global_position.y -= label.get_line_height() * 2
	label.show()

func _unhandled_key_input(event: InputEvent) -> void:
	for key: String in player_accept_input:
		if (Input.is_action_just_pressed(key)):
			for interacting_body: Node2D in body_areas:
				if (interacting_body.name == player_accept_input[key] && !body_interacting.has(interacting_body)):
					print(interacting_body.name, player_accept_input[key])
					body_interacting[interacting_body] = true
					var areas: Array = body_areas[interacting_body]
					if (areas.is_empty()):
						continue
					print(interacting_body, ":", areas[0])
					# TODO: disable ability to interact for interacting_body
					await areas[0].interact.call()
					body_interacting.erase(interacting_body)
