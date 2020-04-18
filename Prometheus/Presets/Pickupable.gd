extends Area2D

func _ready():
	set_process(true)

func _process(delta):
	# Destroy every colliding areas
	var colliding_areas = get_overlapping_bodies()
	if len(colliding_areas) > 0 :
		colliding_areas[0].random_props["hasMirror"] = true
		print(colliding_areas[0].random_props["hasMirror"])
		queue_free()
