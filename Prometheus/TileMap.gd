extends TileMap

export var _seed = 271382
export var CHUNK_SIZE = 64
export var GEN_RADIUS = 2

export var FLOOR_SCALE = 2.0
export var FLOOR_TO_AIR_RATIO = .1
export var VARIATION = 10.0
export var VARIATION_SCALE = 20.0

const pi = 3.14159265359

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player

var noise = OpenSimplexNoise.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("player")
	
	# Configure Noice
	noise.seed = _seed
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8

	pass

var chunk_pos = Vector2(100,100)
var raw_pos = Vector2(0,0)
var generated = {}

func remap_range(input, minInput, maxInput, minOutput, maxOutput):
	return(input - minInput) / (maxInput - minInput) * (maxOutput - minOutput) + minOutput

func platform_exact(pos):
	return cos(pos.y * pi / FLOOR_SCALE + noise.get_noise_2dv(pos/VARIATION_SCALE) * VARIATION) + FLOOR_TO_AIR_RATIO

func platform_noise(pos):
	return platform_exact(pos) * max(noise.get_noise_2dv(pos), 0)

func generate_chunk(coords):
	# Double Generation Protection
	if generated.has(coords):
		return
	generated[coords] = null
	
	var top_left_tile = coords * CHUNK_SIZE
	var pos
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			pos = top_left_tile + Vector2(x, y)
			if platform_noise(pos) < 0:
				set_cellv(pos, 0)
			
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	raw_pos += Vector2(int(Input.is_action_pressed("ui_right")), int(Input.is_action_pressed("ui_down"))) * CHUNK_SIZE
	raw_pos += Vector2(-int(Input.is_action_pressed("ui_left")), -int(Input.is_action_pressed("ui_up"))) * CHUNK_SIZE
	
	var pos = world_to_map(player.position)
	
	# Update Chunks when you step into a new one
	if not chunk_pos == (pos / CHUNK_SIZE).floor() :
		chunk_pos = (pos / CHUNK_SIZE).floor()
		generate_chunk(chunk_pos + Vector2.UP)
		generate_chunk(chunk_pos + Vector2.UP + Vector2.RIGHT)
		generate_chunk(chunk_pos + Vector2.UP + Vector2.LEFT)
		generate_chunk(chunk_pos + Vector2.RIGHT)
		generate_chunk(chunk_pos + Vector2.LEFT)
		generate_chunk(chunk_pos + Vector2.DOWN)
		generate_chunk(chunk_pos + Vector2.DOWN + Vector2.RIGHT)
		generate_chunk(chunk_pos + Vector2.DOWN + Vector2.LEFT)
		generate_chunk(chunk_pos)
	
	
