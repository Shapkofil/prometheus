extends AudioStreamPlayer

export var sample_library = {"ouch": preload("res://Player/Sounds/ouch.wav"), 
"jump": preload("res://Player/Sounds/jump-sound-effect.wav"),
"huh": preload("res://Player/Sounds/huh.wav"),
"hah_attack": preload("res://Player/Sounds/hah_attack.wav"),
"fire_ball": preload("res://Player/Sounds/fireball-sound-effect.wav"),
"explosion": preload("res://Player/Sounds/explosion-sound-effect.wav"),
}

func _ready():
	pass

func play_sample(var sound):
	if sample_library.has(sound):
		stream = sample_library[sound]
		play()

