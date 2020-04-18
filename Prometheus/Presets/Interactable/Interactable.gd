extends Area2D

func _ready():
	set_process(true)

func execute(collisions):
	pass
	
func _process(delta):
	# Destroy every colliding areas
	var colliding_areas = get_overlapping_bodies()
	execute(colliding_areas)
	
