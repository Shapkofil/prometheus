extends "res://Presets/Interactable/Interactable.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalVars.hasMirror == true:
		visible = false

func execute(collisions):
	GlobalVars.hasMirror = true
	for collision in collisions:
		if collision.name == "player":
			collision.random_props['hasMirror'] = true
			queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
