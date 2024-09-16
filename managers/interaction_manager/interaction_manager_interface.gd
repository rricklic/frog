class_name InteractionManagerInterface extends ManagerInterface

func register(area: InteractionArea, interacting_body: Node2D) -> void:
	var manager: InteractionManager = _get_or_create_manager()
	manager.register(area, interacting_body)
	
func deregister(area: InteractionArea, interacting_body: Node2D) -> void:
	var manager: InteractionManager = _get_or_create_manager()
	manager.deregister(area, interacting_body)
