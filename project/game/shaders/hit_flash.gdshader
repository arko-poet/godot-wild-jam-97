shader_type canvas_item;

uniform float flash_amount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 new_color = COLOR;
    new_color.rgb = mix(new_color.rgb, vec3(1.0), flash_amount);
    COLOR = new_color;
}