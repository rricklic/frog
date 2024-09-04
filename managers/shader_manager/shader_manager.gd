class_name ShaderManager extends Node

signal finished

const GROUP: String = "ShaderManager"

func _ready() -> void:
	add_to_group(GROUP)

func perform(canvas_item: CanvasItem, parameters: ShaderParameters) -> void:
	var target: CanvasItem
	
	#var tmps: Array[Node]
	if (parameters.is_screen_shader):
		var back_buffer_copy: BackBufferCopy = _create_backbuffer()
		var texture_rect: TextureRect = _create_texture_rect()
		canvas_item.add_child(back_buffer_copy)
		canvas_item.add_child(texture_rect)
		#tmps.append(back_buffer_copy)
		#tmps.append(texture_rect)
		target = texture_rect
	else:
		target = canvas_item

	var original_material: Material = target.material
	var shader_material: ShaderMaterial = _create_shader_material(parameters.shader)
	target.material = shader_material

	for static_parameter: StaticFloatShaderParam in parameters.static_float_params:
		shader_material.set_shader_parameter(static_parameter.name, static_parameter.value)
	for static_parameter: StaticColorShaderParam in parameters.static_color_params:
		shader_material.set_shader_parameter(static_parameter.name, static_parameter.value)

	var tween: Tween = create_tween()
	tween.set_parallel(true)
	for dynamic_parameter: DynamicFloatShaderParam in parameters.dynamic_float_params:
		tween.tween_method(_tween_property.bind(dynamic_parameter.name, shader_material),
				dynamic_parameter.start_value, dynamic_parameter.end_value, dynamic_parameter.duration)
				
	await tween.finished
	
	#target.material = original_material # TODO: reset target materia???
	
	finished.emit()

func _create_backbuffer() -> BackBufferCopy:
	var back_buffer_copy: BackBufferCopy = BackBufferCopy.new()
	back_buffer_copy.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT
	return back_buffer_copy

func _create_texture_rect() -> TextureRect:
	var texture_rect = TextureRect.new()
	texture_rect.anchors_preset = Control.LayoutPreset.PRESET_FULL_RECT
	texture_rect.size = get_tree().root.content_scale_size
	texture_rect.texture = PlaceholderTexture2D.new()
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return texture_rect;

func _create_shader_material(shader: Shader) -> ShaderMaterial:
	var shader_material: ShaderMaterial = ShaderMaterial.new()
	shader_material.shader = shader
	shader_material.resource_local_to_scene = true
	return shader_material;

func _tween_property(amount: float, name: String, shader_material: ShaderMaterial) -> void:
	shader_material.set_shader_parameter(name, amount)
