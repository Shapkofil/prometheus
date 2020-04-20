extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
var _timer = null


func _ready():
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(0.1)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()

func _on_Timer_timeout():
	if get_frame() == 2:
		set_frame(0)
	else:
		set_frame(get_frame() + 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
