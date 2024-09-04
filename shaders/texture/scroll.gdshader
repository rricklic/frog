shader_type canvas_item;

uniform float x_speed = 0.1;
uniform float y_speed = 0.1;
uniform float angle = 0.5;

vec2 rotateUV (vec2 uv, vec2 pivot, float rotation) {
    float sine = sin(rotation);
    float cosine = cos(rotation);
    uv -= pivot;
    uv.x = uv.x * cosine - uv.y * sine;
    uv.y = uv.x * sine + uv.y * cosine;
    uv += pivot;
    return uv;
}

void vertex() {
	UV.x += TIME * x_speed;
	UV.y += TIME * y_speed;

}

void fragment() {
    COLOR = texture(TEXTURE, rotateUV(UV, vec2(0.5), angle));
}