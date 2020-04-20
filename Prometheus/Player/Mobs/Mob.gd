extends KinematicBody2D

var target
var tile_map
var visual

export var GRAVITY = 1000
export var SPEED = 200

func _ready():
	target = .get_tree().get_root().get_node("Node2D").get_node("player")
	tile_map = .get_tree().get_root().get_node("Node2D").get_node("TileMap")
	visual = get_node("AnimatedSprite")

var velocity = Vector2.ZERO

func _process(delta):
	velocity = Vector2.DOWN * GRAVITY
	velocity += (target.global_position - global_position).normalized() * SPEED
	visual.flip_h = velocity.x>0
	visual.position.x = abs(visual.position.x) * 2.0*(int(velocity.x>0)-.5)
	
	move_and_slide(velocity)
	pass
