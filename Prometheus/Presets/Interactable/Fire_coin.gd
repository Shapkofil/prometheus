extends "res://Presets/Interactable/Interactable.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func execute(collisions):
	for collision in collisions:
		if collision.name == "player":
			collision.affect_fire(1,0)
			get_parent().queue_free()
			GlobalVars.score += 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
