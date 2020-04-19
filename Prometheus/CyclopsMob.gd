extends KinematicBody2D

var direction = false

func _ready():
	position = Vector2(100, 200)

export var GRAVITY = 700.0 # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
export var FLOOR_ANGLE_TOLERANCE = 40
export var WALK_FORCE = 600
export var WALK_MIN_SPEED = 10
export var WALK_MAX_SPEED = 200

export var SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
export var SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

var velocity = Vector2()
var on_air_time = 100

var random_props = {}



func _physics_process(delta):
	# Create forces
	var force = Vector2(0, GRAVITY)

	if direction:
		if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
			force.x -= WALK_FORCE
			$AnimatedSprite.play("move-loop")
			$AnimatedSprite.flip_h = false
		
	elif direction == false:
		if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
			force.x += WALK_FORCE
			$AnimatedSprite.play("move-loop")
			$AnimatedSprite.flip_h = true
	
	# Integrate forces to velocity
	velocity += force * delta
	# Integrate velocity into motion and move
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if position.x > 250 and direction == false:
		direction = true
	
	if position.x < -5 and direction == true:
		direction = false
