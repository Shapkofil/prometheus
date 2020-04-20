extends KinematicBody2D

var direction = false

func _ready():
	position = Vector2(100, 200)

export var GRAVITY = 700.0 # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
export var WALK_FORCE = 600
export var SPEED = 200

export var SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
export var SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

var velocity = Vector2()
var on_air_time = 100

var random_props = {}



func _physics_process(delta):
	var force = Vector2(0,GRAVITY)
	
	velocity += force * delta
	
	move_and_slide(velocity, Vector2(0,-1))
