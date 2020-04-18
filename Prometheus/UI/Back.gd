extends Button



func _ready():
	pass # Replace with function body.


func _on_Back_pressed():
	get_tree().change_scene(GlobalVars.lastScene)
