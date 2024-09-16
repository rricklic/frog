shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float scan_line_count: hint_range(0.0, 1800.0) = 50.0;

const float r_factor = 0.0;
const float g_factor = 1.0;
const float b_factor = -1.0;

vec2 uv_curve(vec2 uv)
{
	uv = (uv - 0.5) * 2.0;
	uv.x *= 1.0 + pow(abs(uv.y) / 8.0, 2.0);
	uv.y *= 1.0 + pow(abs(uv.x) / 4.5, 2.0);
	uv /= 1.2;
	uv = (uv / 2.0) + 0.5;
	return uv;
}

void fragment()
{
	float r = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x * r_factor), 0.0).r;
	float g = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x * g_factor), 0.0).g;
	float b = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x * b_factor), 0.0).b;
	float s = sin(uv_curve(SCREEN_UV).y * scan_line_count * PI * 2.0);
	s = (s * 0.5 + 0.5) * 0.9 + 0.1;
	vec4 scan_line = vec4(vec3(pow(s, 0.25)), 1.0);
	COLOR = vec4(r, g, b, 1.0) * scan_line;
}