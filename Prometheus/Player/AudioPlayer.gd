extends AudioStreamPlayer

var sample_library = {"ouch": preload("res://Player/Sounds/ouch.wav"), 
"jump": preload("res://Player/Sounds/jump.wav"),
"huh": preload("res://Player/Sounds/huh.wav"),
"hah_attack": preload("res://Player/Sounds/hah_attack.wav"),
}

func _ready():
	pass

func play_sample(var sound):
	if sample_library.has(sound):
		stream = sample_library[sound]
		play()

