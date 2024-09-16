class_name InteractionArea extends Area2D

@export var interaction_name: String = "Interact"

var interact: Callable = func():
	pass

@onready var interaction_manager_interface: InteractionManagerInterface = $InteractionManagerInterface

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	interaction_manager_interface.register(self, body)
	
func _on_body_exited(body: Node2D) -> void:
	interaction_manager_interface.deregister(self, body)
