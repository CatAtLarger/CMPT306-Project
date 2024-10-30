shader_type canvas_item;


uniform vec4 tint_color : source_color;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 tex_color = texture(TEXTURE, SCREEN_UV); // Sample texture using screen UV
    COLOR = tex_color * tint_color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
