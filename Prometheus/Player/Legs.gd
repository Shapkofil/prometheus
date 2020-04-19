extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player
var particles

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent()
	particles = get_node("DurtParticles")
	set_process(true)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.velocity.y==0 and not player.velocity.x==0:
		particles.emitting = true
		scale.x = max(min(player.velocity.x,.5),-.5)
	else:
		particles.emitting = false
	pass
