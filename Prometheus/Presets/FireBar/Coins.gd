extends TileMap


var _tileset
var init_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	_tileset = get_tileset()
	init_pos = world_to_map(get_parent().get_node("BottomPlace").position)


func update_fire(curr, maxi):
	var tile_pos = init_pos
	clear()
	for i in range(curr):
		set_cellv(tile_pos, _tileset.find_tile_by_name("Coin"))
		tile_pos.y -= 1
	pass
	
	 

