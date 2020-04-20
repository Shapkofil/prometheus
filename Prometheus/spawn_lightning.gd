extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var lightningPacked = preload("res://Presets/Interactable/Lightning/lightning.tscn")
onready var warningPacked = preload("res://Presets/Interactable/Lightning/warning.tscn")
var _timer = null
var lightning = null
var warning = null

func _ready():
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(5)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	

func _on_Timer_timeout():
	lightning = lightningPacked.instance()
	warning = warningPacked.instance()
	# var newPos = Vector2($player.global_position.x + rand_range(-10, 10), $player.global_position.y)
	var newX = $player.global_position.x + rand_range(-200, 200)
	var newY = $player.global_position.y - 50
	warning.position.x = newX
	warning.position.y = newY
	lightning.position.x = newX
	lightning.position.y = newY
	get_tree().get_root().add_child(warning)
	for i in range(100):
		yield(get_tree(), "idle_frame")
	warning.queue_free()
	get_tree().get_root().add_child(lightning)
	for i in range(100):
		yield(get_tree(), "idle_frame")
	lightning.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
