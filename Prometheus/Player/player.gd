extends KinematicBody2D

# This demo shows how to build a kinematic controller.

# Member variables
export var GRAVITY = 700.0 # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
export var FLOOR_ANGLE_TOLERANCE = 40
export var WALK_FORCE = 600
export var WALK_MIN_SPEED = 10
export var WALK_MAX_SPEED = 200
export var STOP_FORCE = 2000
export var JUMP_SPEED = 500
export var JUMP_MAX_AIRBORNE_TIME = 0.2
export var TIME_FLEX = .2

export var DAMAGE_SKIP = .5

export var SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
export var SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

var velocity = Vector2()
var on_air_time = 100
var jumping = false
var jump_delay = .0
var on_ground_delay = .0
var hitstun = 0
var knockdir = Vector2(0, 0)
var _delta
var attack_cooldown = 0

var random_props = {}

var prev_jump_pressed = false

# Stats
export var fire = 5
export var max_fire = 6

onready var fireballPacked = preload("res://Presets/Interactable/FireBall/fireball.tscn")
onready var explosionPacked = preload("res://Presets/Interactable/Explosion/explosion.tscn")

func _ready():
	GlobalVars.lastScene = "res://Node2D.tscn"
	get_tree().paused = false

var fire_subscribers = []

func subscribe(subscriber):
	fire_subscribers.append(subscriber)
	
func take_damage(source, force):
	if hitstun < 0:
		hitstun = DAMAGE_SKIP
		affect_fire(-1, 0)
		take_knockback(source, force)
		$ouch.play()
	else:
		hitstun -= _delta
	
func take_knockback(source, force):
		knockdir = (source.position - self.global_position).normalized()
		velocity += knockdir * force

func explode():
	var explosion = explosionPacked.instance()
	explosion.position.x = global_position.x
	explosion.position.y = global_position.y
	get_tree().get_root().add_child(explosion)

func affect_fire(t, e):
	fire += t;
	max_fire += e;
	if fire == 0:
		$DeathLayer/DeathPopup.visible = true
		get_tree().paused = true
	if fire == max_fire:
		explode()
	for sub in fire_subscribers:
		sub.update_fire()

func _physics_process(delta):
	# Create forces
	_delta = delta
	var force = Vector2(0, GRAVITY)
	var fireball = fireballPacked.instance()
	
	if attack_cooldown > 0:
		attack_cooldown -= 1
	
	if Input.is_action_just_pressed("action"):
		if attack_cooldown == 0 and fire > 1:
			fireball.position.x = self.position.x
			fireball.position.y = self.position.y
			get_tree().get_root().add_child(fireball)
			if $AnimatedSprite.flip_h == false:
				fireball.flip_h = true
			else:
				fireball.flip_h = false
			attack_cooldown = 30
			affect_fire(-1, 0)

	var walk_left = Input.is_action_pressed("ui_left")
	var walk_right = Input.is_action_pressed("ui_right")
	var jump = Input.is_action_pressed("ui_up") or Input.is_action_pressed("jump")
	var stop = true

	if walk_left:
		if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
			force.x -= WALK_FORCE
			stop = false
			$AnimatedSprite.play("move-loop")
			$AnimatedSprite.flip_h = false
		
	elif walk_right:
		if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
			force.x += WALK_FORCE
			stop = false
			$AnimatedSprite.play("move-loop")
			$AnimatedSprite.flip_h = true

	if stop:
		
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)

		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
			$AnimatedSprite.play("idle-loop")

		velocity.x = vlen * vsign
		
	delays(jump, is_on_floor(), delta) 

	if on_ground_delay<TIME_FLEX and jump_delay<TIME_FLEX:
		on_air_time = 0
		jumping = true

	if jumping and not jump:
		# If falling, no longer jumping
		velocity.y *= .5
		jumping = false

	if jump and jumping and on_air_time<JUMP_MAX_AIRBORNE_TIME:
		velocity.y = -JUMP_SPEED

	if not is_on_floor() :
		$AnimatedSprite.play("jump-loop")
		
		# Integrate forces to velocity
	velocity += force * delta
	# Integrate velocity into motion and move
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	on_air_time += delta
	
	
	
func delays(jump, ground, delta):
	jump_delay += delta
	on_ground_delay += delta
	
	if jump:
		jump_delay = 0
	
	if ground:
		on_ground_delay = 0
