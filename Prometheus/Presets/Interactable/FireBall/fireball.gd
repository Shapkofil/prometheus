extends "res://Presets/Interactable/Interactable.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func execute(collisions):
	for collision in collisions:
		print(collision.name)
		if "Cyclops" in collision.name or "Gorgona" in collision.name or "Centauros" in collision.name:
			collision.queue_free()
			self.get_parent().queue_free()
			GlobalVars.score += 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
