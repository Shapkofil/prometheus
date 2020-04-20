extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func animate():
	for i in range(0, 64):
		set_frame(i)
		yield(get_tree(), "idle_frame")
	queue_free()
# Called when the node enters the scene tree for the first time.
func _ready():
	animate()


# Called every frame. 'delta' is the elapsed time since the previous frame.

