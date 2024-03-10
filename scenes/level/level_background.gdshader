shader_type canvas_item;

uniform vec4 color: source_color;
uniform sampler2D noise;
uniform vec2 offset;

void fragment() {
	vec2 point = mod(UV + (offset * .0005), 1.0);
	vec4 noise_val = texture(noise, point);

	float color_mult = 1.0;
	if (noise_val.r <= 0.3) {
		color_mult = 0.7;
	} else if (noise_val.r <= 0.6) {
		color_mult = 0.8;
	}
	COLOR = color * vec4(color_mult, color_mult, color_mult, 1.0);
}
