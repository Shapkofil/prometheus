extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVars.lastScene = "res://UI/MainMenu.tscn"

func _on_Play_pressed():
	get_tree().change_scene("res://Procedural.tscn")


func _on_Settings_pressed():
	get_tree().change_scene("res://UI/Settings.tscn")
