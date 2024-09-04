shader_type canvas_item;

// Fade entire screen to or from a color

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float amount : hint_range(0.0, 1.0) = 0.5;
uniform vec4 target_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment()
{
	vec4 pixel_color = texture(SCREEN_TEXTURE, SCREEN_UV);
	COLOR = mix(pixel_color, target_color, amount);
}
