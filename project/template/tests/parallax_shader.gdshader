shader_type canvas_item;

uniform vec2 pixel_resolution = vec2(64.0,64.0);

uniform sampler2D layer : repeat_enable;
uniform vec2 offset = vec2(0.0);
uniform vec2 sub_offset = vec2(0.0);

void fragment() {
	
	float a = round(UV.x * pixel_resolution.x) / pixel_resolution.x;
	float b = round(UV.y * pixel_resolution.y) / pixel_resolution.y;
	vec2 p_uv = vec2(a,b);
	COLOR = texture(layer, p_uv + offset + sub_offset);
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
