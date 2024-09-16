shader_type canvas_item;

// TODO: fix and test

uniform sampler2D dissolve_texture;
uniform float amount : hint_range(0.0, 1.1) = 0.0;

void fragment()
{
	COLOR = texture(TEXTURE, UV);
	float pattern = texture(dissolve_texture, UV).r;
	COLOR.a *= step(amount, pattern);
}