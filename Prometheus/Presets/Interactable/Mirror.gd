extends "res://Presets/Interactable/Interactable.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func execute(collisions):
	for collision in collisions:
		if collision.name == "player":
			collision.random_props['hasMirror'] = true
			queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
