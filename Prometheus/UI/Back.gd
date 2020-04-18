extends Button



func _ready():
	pass # Replace with function body.


func _on_Back_pressed():
	var sceneToGo = GlobalVars.lastScene
	get_tree().change_scene("res://UI/MainMenu.tscn")
