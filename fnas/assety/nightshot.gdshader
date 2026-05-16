shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

const float QUANTIZATION_FACTOR = 16.0;

void fragment() {
    vec4 px = textureLod(screen_texture, SCREEN_UV, 0.0);
	float oc = (px.r + px.g + px.b) / 3.0;
	float c = round(oc * QUANTIZATION_FACTOR) / QUANTIZATION_FACTOR;
	COLOR = vec4(c / 4.0, c, c / 4.0, 1);
}
