extends Button

func _ready():
	pass 


func _on_Resume_pressed():
	get_tree().paused = not get_tree().paused
	visible = not get_tree().paused
