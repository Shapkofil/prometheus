extends "res://Presets/Interactable/Interactable.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalVars.hasCoin == true:
		visible = false

func execute(collisions):
	GlobalVars.hasCoin = true
	for collision in collisions:
		if collision.name == "player":
			collision.affect_fire(1,0)
			queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
