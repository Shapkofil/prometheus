shader_type canvas_item;

uniform vec4 color: hint_color;
uniform vec2 resolution;
uniform float vignette_power;
uniform float vignette_density: hint_range(0,2);
uniform float stability: hint_range(0,.2);

vec3 rgb2hsb(vec3 c){
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz),
                vec4(c.gb, K.xy),
                step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r),
                vec4(c.r, p.yzx),
                step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)),
                d / (q.x + e),
                q.x);
}

float rand(float time){
	vec2 co = vec2(time, .0);
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float vignette(vec2 uv, float value, float density)
{
	uv  = 2.*(uv-.5);
	uv  = cos(uv * resolution/ resolution.y);
	return min(pow(max((uv.x + uv.y) - density, .0), value), 1);
}

void fragment()
{
	vec4 initial = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	float gray = rgb2hsb(initial.xyz).z;
	COLOR = vec4((vec3(1.,1.,1.)*gray)*color.xyz*vignette(UV, vignette_power, vignette_density + sin(rand(TIME))*stability),initial.w);
}
