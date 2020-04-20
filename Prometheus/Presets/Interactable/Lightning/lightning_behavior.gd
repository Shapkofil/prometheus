extends Node2D


onready var warningPacked = preload("res://Presets/Interactable/Lightning/warning.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var DELAY = .5
export var TIMESTEP = .1
export var LIFETIME = 2.0
export var TRAIL_LEN = 3

var seeker
var tile_map
var visual
var audio_player


var scanning = true
var iter = 0
var _timer
# Called when the node enters the scene tree for the first time.
func _ready():
	seeker = get_node("Seeker")
	tile_map = get_parent()
	visual = get_node('Visual')
	audio_player = visual.get_node('Audio')
	visual.scale.x = 0
	
	# Delay timer
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_on_delay_end")
	_timer.set_wait_time(DELAY)
	
	pass # Replace with function body.

var last_tick = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	last_tick+=delta
	if last_tick >= TIMESTEP:
		last_tick = 0
		update_seeker(delta)


func update_seeker(delta):
	print(scanning)
	if not scanning:
		return;
	
	iter += 1
	seeker.position += Vector2.DOWN*tile_map.cell_size.y
	var warning_sign = warningPacked.instance()
	warning_sign.position = seeker.position
	warning_sign.DELAY= TIMESTEP*TRAIL_LEN
	add_child(warning_sign)
	var scan_pos = tile_map.world_to_map(seeker.global_position) + Vector2.DOWN
	if not tile_map.get_cellv(scan_pos) == -1:
		_timer.start()
		scanning = false
	pass
	
func _on_delay_end():
	seeker.scale = Vector2(0,0)
	visual.position.y = (seeker.position.y + tile_map.cell_size.y) / 2
	visual.scale.x = iter + 1
	visual.material.set_shader_param("resolution",Vector2(1,scale.y))
	audio_player.play()
	
	_timer.stop()
	_timer.connect("timeout", self, "_on_lifetime_end")
	_timer.set_wait_time(LIFETIME)
	_timer.start()
	
func _on_lifetime_end():
	queue_free()
