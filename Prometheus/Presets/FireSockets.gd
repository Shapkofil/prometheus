extends TileMap


var _tileset
var init_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	_tileset = get_tileset()
	init_pos = world_to_map(get_parent().get_node("BottomPlace").position)
	update_fire(0,6)


func update_fire(curr, maxi):
	var tile_pos = init_pos
	set_cellv(tile_pos, _tileset.find_tile_by_name("Bottom_socket"))
	for i in range(maxi - 1):
		tile_pos.y -= 1
		set_cellv(tile_pos, _tileset.find_tile_by_name("Middle_socket"))
	set_cellv(tile_pos, _tileset.find_tile_by_name("Top_socket"))
	pass
	
	 
