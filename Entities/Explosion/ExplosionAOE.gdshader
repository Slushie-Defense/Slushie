shader_type canvas_item;

void fragment() {
    COLOR = texture(TEXTURE, UV);
    float gray = dot(COLOR.rgb, vec3(0.299, 0.587, 0.114));
    float dist = length(COLOR.rgb - vec3(1.0, 1.0, 1.0));
    if (dist < 0.1) {
        COLOR.rgb = vec3(1.0, 1.0, 0.0);
    } else {
        //COLOR.rgb = vec3(1.0, 0.0, 0.0) * gray;
		COLOR.rgb = vec3(1.0, 0.5, 0.0) * gray;
    }
}
