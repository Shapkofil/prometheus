extends Control


func _ready():
	GlobalVars.lastScene = "res://UI/PauseMenu.tscn"

func _on_Resume_pressed():
	get_tree().change_scene("res://Node2D.tscn")
