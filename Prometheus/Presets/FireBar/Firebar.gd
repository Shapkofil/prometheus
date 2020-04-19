extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().subscribe(self)
	update_fire()


func update_fire():
	var player = get_parent()
	for i in range(2):
		get_child(i).update_fire(player.fire, player.max_fire)
