extends KinematicBody2D

var direction = false

func _ready():
	position = Vector2(30, 70)

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


export var fire = 5
export var max_fire = 6
var _delta
var hitstun = 0
export var DAMAGE_SKIP = .5
var fire_subscribers = []
var knockdir = Vector2(0, 0)
export var knockback_force = 100

func take_damage(source, force):
	if hitstun < 0:
		hitstun = DAMAGE_SKIP
		affect_fire(-1, 0)
		take_knockback(source, force)
		get_parent().get_parent().get_child(1).get_child(2).play()
	else:
		hitstun -= _delta
		
func affect_fire(t, e):
	fire += t;
	max_fire += e;
	if fire == 0:
		get_parent().get_parent().get_child(1).get_child(4).get_child(0).visible = true
		get_tree().paused = true
	for sub in fire_subscribers:
		sub.update_fire()

func take_knockback(source, force):
		knockdir = (source.position - self.global_position).normalized()
		velocity += knockdir * force



func _physics_process(delta):
	_delta = delta
	var force = Vector2(0,GRAVITY)
	
	velocity += force * delta
	
	move_and_slide(velocity, Vector2(0,-1))
	
	if direction:
		position.x -= 1
		$AnimatedSprite.play("move-loop")
		$AnimatedSprite.flip_h = false
		checksForDirection = position.x - 30
	
	elif !direction:
		position.x += 1
		$AnimatedSprite.play("move-loop")
		$AnimatedSprite.flip_h = true
		checksForDirection = position.x + 30
	
	var positionOfEnemyOnGround = Vector2(checksForDirection, position.y + 76)
	var positionOfEnemyBeforeWall = Vector2(checksForDirection, position.y)
	var tileOnGround = get_tree().get_current_scene().get_node("TileMap").get_cellv(get_tree().get_current_scene().get_node("TileMap").world_to_map(positionOfEnemyOnGround))
	var tileBeforWall = get_tree().get_current_scene().get_node("TileMap").get_cellv(get_tree().get_current_scene().get_node("TileMap").world_to_map(positionOfEnemyBeforeWall))
	if tileOnGround == get_parent().INVALID_CELL or tileBeforWall != get_parent().INVALID_CELL: 
		direction = not direction
		
	var movement = Vector2(-1, 0)
	var collisions = move_and_collide(movement * delta)
	if collisions != null:
		if collisions.collider_id == get_parent().get_parent().get_child(1).get_instance_id():
			take_damage(get_parent().get_parent().get_child(1), knockback_force)
	
