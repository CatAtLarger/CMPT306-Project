shader_type canvas_item;

uniform vec2 shimmer_direction = vec2(1.0, 0.5); // Direction of the shimmer
uniform float shimmer_speed = 5.0; // Speed of the shimmer
uniform float shimmer_width = 0.1; // Width of the shimmer band
uniform float shimmer_intensity = 0.2; // Brightness of the shimmer
uniform float shimmer_interval = 6.0; // Time between shimmers (in seconds)

void fragment() {
    vec2 uv = UV;

    // Calculate a time-based shimmer effect with periodic delay
    float interval_time = mod(TIME, shimmer_interval); // Repeat every shimmer_interval seconds
    float shimmer = 0.0;

    if (interval_time < shimmer_interval * 0.5) {
        // Shimmer only occurs during the first half of the interval
        float shimmer_t = interval_time * shimmer_speed; 
        shimmer = abs(sin(shimmer_t + uv.x * shimmer_direction.x + uv.y * shimmer_direction.y));
        shimmer = smoothstep(1.0 - shimmer_width, 1.0, shimmer) * shimmer_intensity;
    }

    // Combine shimmer with the texture
    vec4 tex_color = texture(TEXTURE, uv);
    COLOR = tex_color + vec4(shimmer, shimmer, shimmer, 0.0);
}
