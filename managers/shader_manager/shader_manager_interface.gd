class_name ShaderManagerInterface extends ManagerInterface

func _ready() -> void:
	_setup(ShaderManager.GROUP)

func perform(canvas_item: CanvasItem, parameters: ShaderParameters) -> void:
	var shader_manager: ShaderManager = _get_manager()
	shader_manager.perform(canvas_item, parameters)
	await shader_manager.finished
