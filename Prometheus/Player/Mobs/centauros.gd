extends KinematicBody2D

var direction = false

func _ready():
	position = Vector2(-400, 0)

export var GRAVITY = 700.0 # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
export var WALK_FORCE = 600
export var SPEED = 200

export var SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
export var SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

var velocity = Vector2()
var on_air_time = 100

var random_props = {}

var checksForDirection

func _physics_process(delta):
	var force = Vector2(0,GRAVITY)
	
	velocity += force * delta
	
	move_and_slide(velocity, Vector2(0,-1))
	
	if direction:
		position.x -= 1
		$AnimatedSprite.play("charge-loop")
		$AnimatedSprite.flip_h = false
		checksForDirection = position.x - 50
	
	elif !direction:
		position.x += 1
		$AnimatedSprite.play("charge-loop")
		$AnimatedSprite.flip_h = true
		checksForDirection = position.x + 50
	
	var positionOfEnemyOnGround = Vector2(checksForDirection, position.y + 128)
	var positionOfEnemyBeforeWall = Vector2(checksForDirection, position.y)
	var tileOnGround = get_tree().get_current_scene().get_node("TileMap").get_cellv(get_tree().get_current_scene().get_node("TileMap").world_to_map(positionOfEnemyOnGround))
	var tileBeforWall = get_tree().get_current_scene().get_node("TileMap").get_cellv(get_tree().get_current_scene().get_node("TileMap").world_to_map(positionOfEnemyBeforeWall))
	if tileOnGround == get_parent().INVALID_CELL or tileBeforWall != get_parent().INVALID_CELL: 
		direction = not direction
