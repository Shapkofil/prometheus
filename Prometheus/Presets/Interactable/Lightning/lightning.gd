extends "res://Presets/Interactable/Interactable.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var knockback_force = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func execute(collisions):
	for collision in collisions:
		if collision.name == "player":
			collision.take_damage(self.get_child(0), knockback_force)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
