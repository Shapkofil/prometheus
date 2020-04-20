extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var DELAY = .5

# Called when the node enters the scene tree for the first time.
func _ready():
	var _timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_on_delay_end")
	_timer.set_wait_time(DELAY)
	_timer.start()
	pass # Replace with function body.

func _on_delay_end():
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
