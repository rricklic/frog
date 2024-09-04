shader_type canvas_item;

// texture() - function to manipulate texture: which texture, where to manipulate (UV coordinate e.g.: 0-1)
// TEXTURE - (constant) texture of this shader
// UV - (constant) UV coordinate of this sampling
// COLOR - the color of this pixel
// uniform - shader input constant value; can be set in IDE from "Shader Parameters"
// hint_range() - define the valid values for a uniform
// source_color - hint that IDE should only allow color
// mix(source, dest, interpolation) - function to interpolate between source and destination color

uniform vec4 target_color : source_color = vec4(0.0, 0.75, 0.25, 1.0);
uniform float amount : hint_range(0.0, 1.0) = 0.5;

void fragment()
{
	vec4 pixel_color = texture(TEXTURE, UV); // Sample this pixel
	COLOR = mix(pixel_color, target_color, amount); // Set this pixel
	COLOR.a *= pixel_color.a; // Preserve alpha
}