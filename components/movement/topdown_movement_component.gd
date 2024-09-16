class_name TopDownMovementComponent extends Node

@export_category("Input")
@export var up_action: String = "ui_up"
@export var down_action: String = "ui_down"
@export var left_action: String = "ui_left"
@export var right_action: String = "ui_right"
@export_category("Movement")
@export var speed: float = 300.0

# TODO: dash
# TODO: walk vs run
# TODO: movement multiplier

func _physics_process(delta: float) -> void:
	var x_direction: float = Input.get_axis(left_action, right_action)
	if x_direction:
		owner.velocity.x = x_direction * speed
	else:
		owner.velocity.x = move_toward(owner.velocity.x, 0, speed)

	var y_direction = Input.get_axis(up_action, down_action)	
	if y_direction:
		owner.velocity.y = y_direction * speed
	else:
		owner.velocity.y = move_toward(owner.velocity.y, 0, speed)

	owner.move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	pass
