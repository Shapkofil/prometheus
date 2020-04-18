extends Control


func _ready():
	GlobalVars.lastScene = "res://UI/PauseMenu.tscn"

func _on_Resume_pressed():
	get_tree().change_scene("res://Node2D.tscn")


func _on_RestartLevel_pressed():
	GlobalVars.playerSavedPosition = [100, 0]
	get_tree().change_scene("res://Node2D.tscn")
