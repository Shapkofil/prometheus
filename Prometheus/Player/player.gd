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

export var SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
export var SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

var velocity = Vector2()
var on_air_time = 100
var jumping = false

var random_props = {}

var prev_jump_pressed = false

# Stats
export var fire = 5
export var max_fire = 6



func _ready():
	var positionX = GlobalVars.playerSavedPosition[0]
	var positionY = GlobalVars.playerSavedPosition[1]
	position = Vector2(positionX, positionY)
	GlobalVars.lastScene = "res://Node2D.tscn"
	get_tree().paused = false

var fire_subscribers = []

func subscribe(subscriber):
	fire_subscribers.append(subscriber)
	
func affect_fire(t, e):
	fire += t;
	max_fire += e;
	for sub in fire_subscribers:
		sub.update_fire()

func _physics_process(delta):
	# Create forces
	var force = Vector2(0, GRAVITY)

	var walk_left = Input.is_action_pressed("ui_left")
	var walk_right = Input.is_action_pressed("ui_right")
	var jump = Input.is_action_pressed("ui_up")
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

	# Integrate forces to velocity
	velocity += force * delta
	# Integrate velocity into motion and move
	velocity = move_and_slide(velocity, Vector2(0, -1))

	if is_on_floor():
		on_air_time = 0

	if jumping and velocity.y > 0:
		# If falling, no longer jumping
		jumping = false

	if on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping:
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		velocity.y = -JUMP_SPEED
		
		jumping = true

	if jumping:
		$AnimatedSprite.play("jump-loop")
	
	on_air_time += delta
	prev_jump_pressed = jump
	
	GlobalVars.playerSavedPosition = get_position()
	
