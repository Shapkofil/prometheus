extends TileMap

export var _seed = 271382
export var CHUNK_SIZE = 64
export var GEN_RADIUS = 1

export var FLOOR_SCALE = 2.0
export var FLOOR_TO_AIR_RATIO = .1
export var VARIATION = 10.0
export var VARIATION_SCALE = 20.0
export var SPAWN_TIME = 2.0
export var SPAWN_INFLUENCE = .01
export var RANDOM_TICK = 2.0

const pi = 3.14159265359

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player

var noise = OpenSimplexNoise.new()
var _timer

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("player")
	
	# Configure Noice
	noise.seed = _seed
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	
	# Random Tick
	_timer = Timer.new()
	_timer.set_one_shot(false)
	add_child(_timer)
	_timer.connect("timeout", self, "_on_random_tick")
	_timer.set_wait_time(randf()*RANDOM_TICK)
	_timer.start()

	pass

var chunk_pos = Vector2(100,100)
var raw_pos = Vector2(0,0)
var chunk_cache = {}


#--------------------------------
# TERRAIN GENERATION
#--------------------------------

func remap_range(input, minInput, maxInput, minOutput, maxOutput):
	return(input - minInput) / (maxInput - minInput) * (maxOutput - minOutput) + minOutput

func platform_exact(pos):
	return cos(pos.y * pi / FLOOR_SCALE + noise.get_noise_2dv(pos/VARIATION_SCALE) * VARIATION) + FLOOR_TO_AIR_RATIO

func platform_noise(pos):
	return platform_exact(pos) * max(noise.get_noise_2dv(pos), 0)

func generate_chunk(coords):
	# Double Generation Protection
	if chunk_cache.has(coords):
		return
	chunk_cache[coords] = -SPAWN_TIME
	
	var top_left_tile = coords * CHUNK_SIZE
	var pos
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			pos = top_left_tile + Vector2(x, y)
			if platform_noise(pos) < 0:
				set_cellv(pos, tile_set.find_tile_by_name('GrassSet'))
	update_bitmask_region(coords*16, (coords+Vector2(1,1))*16)
	pass

#----------------------------
# SPAWNING ALGORITHM
#----------------------------

export var spawnable = {'res://Presets/Interactable/FireCoin.tscn':.02}
export var dynamic_spawnable = {'res://Presets/Interactable/Lightning/lightning.tscn':.02}

func spawn_noise(pos):
	return platform_noise(pos)*SPAWN_INFLUENCE + rand_range(0, 1)
	
func _on_random_tick():
	print("random_tick")
	var top_left_tile = chunk_pos * CHUNK_SIZE
	var pos
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			pos = top_left_tile + Vector2(x, y)
			if get_cellv(pos) == -1:
				spawn_at(pos, dynamic_spawnable)
	_timer.set_wait_time(randf()*RANDOM_TICK)
	pass

func spawn_at(pos, spawn_set):
	var chance = spawn_noise(pos)
	var attempt = 0
	for path in spawn_set.keys():
		attempt += spawn_set[path]
		if chance < attempt:
			var scene = load(path)
			var entity = scene.instance()
			add_child(entity)
			entity.position = map_to_world(pos, true) + cell_size * .5

func spawn_in_chunk(coords, delta):
	if delta - chunk_cache[coords] < SPAWN_TIME:
		return
	chunk_cache[coords] = delta
	
	var top_left_tile = coords * CHUNK_SIZE
	var pos
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			pos = top_left_tile + Vector2(x, y)
			if get_cellv(pos) == -1:
				spawn_at(pos, spawnable)
	pass


#----------------------------
# MAIN
#----------------------------

func update_chunk(coords, delta):
	generate_chunk(coords)
	spawn_in_chunk(coords, delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	raw_pos += Vector2(int(Input.is_action_pressed("ui_right")), int(Input.is_action_pressed("ui_down"))) * CHUNK_SIZE
	raw_pos += Vector2(-int(Input.is_action_pressed("ui_left")), -int(Input.is_action_pressed("ui_up"))) * CHUNK_SIZE
	
	var pos = world_to_map(player.position)
	
	# Update Chunks when you step into a new one
	if not chunk_pos == (pos / CHUNK_SIZE).floor() :
		chunk_pos = (pos / CHUNK_SIZE).floor()
		for x in range(-GEN_RADIUS,GEN_RADIUS + 1):
			for y in range(-GEN_RADIUS,GEN_RADIUS + 1):
				update_chunk(chunk_pos + Vector2(x,y), delta)
	
	
