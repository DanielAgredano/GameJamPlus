shader_type canvas_item;

uniform int frame = 0;
uniform float transparency = 1.0;
uniform float yMult = 1.0;
uniform float radius = 0.5;
uniform vec2 center = vec2(0.5,0.5);

void fragment() {
	float x = UV.x * 256.0;
	float y = UV.y * 256.0;
	vec2 centerPer = 256.0*center;
	float alpha = float(pow((x-centerPer.x),2)+pow((y-centerPer.y)*yMult,2)>pow(radius*370.0,2));
	COLOR.a = alpha * transparency;
}