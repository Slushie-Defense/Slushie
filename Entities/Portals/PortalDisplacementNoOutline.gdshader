shader_type canvas_item;

uniform float speed = 1.0;
uniform float amplitude = 0.1;
uniform float frequency = 1.0;
uniform sampler2D noise_texture;

void fragment() {
	vec2 uv = UV;
    uv.x += texture(noise_texture, vec2(fract(uv.y * frequency + TIME * speed), uv.x)).r * amplitude;
    COLOR = texture(TEXTURE, uv);
}