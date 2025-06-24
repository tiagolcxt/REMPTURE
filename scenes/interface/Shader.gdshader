shader_type canvas_item;

uniform float radius = 1.0;
uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
    vec2 size = vec2(radius);
    vec4 col = vec4(0.0);
    vec2 uv_step = size / vec2(textureSize(screen_texture, 0));

    for (int x = -2; x <= 2; x++) {
        for (int y = -2; y <= 2; y++) {
            vec2 offset = vec2(float(x), float(y)) * uv_step;
            col += texture(screen_texture, SCREEN_UV + offset);
        }
    }

    col /= 25.0;
    COLOR = col;
}