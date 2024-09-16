class_name ShaderParameters extends Resource

@export var shader: Shader
@export var is_screen_shader: bool
@export var static_float_params: Array[StaticFloatShaderParam]
@export var dynamic_float_params: Array[DynamicFloatShaderParam]
@export var static_color_params: Array[StaticColorShaderParam]

func init(shader_arg: Shader,
		is_screen_shader_arg: bool,
		static_float_params_arg: Array[StaticFloatShaderParam],
		dynamic_float_params_arg: Array[DynamicFloatShaderParam],
		static_color_params_arg: Array[StaticColorShaderParam]
		) -> void:
	shader = shader_arg
	is_screen_shader = is_screen_shader_arg
	static_float_params = static_float_params_arg
	dynamic_float_params = dynamic_float_params_arg
	static_color_params = static_color_params_arg
