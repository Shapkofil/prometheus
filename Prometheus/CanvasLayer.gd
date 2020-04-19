extends CanvasLayer

var isPaused

func _ready():
	pass


func _input(event):
	if event.is_action_pressed("ui_pause"):
		isPaused = not get_tree().paused
		get_tree().paused = not get_tree().paused
		get_child(0).visible = isPaused


func _on_Resume_pressed():
	get_tree().paused = not get_tree().paused
	get_child(0).visible = not isPaused



func _on_Settings_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/Settings.tscn")


func _on_RestartLevel_pressed():
	GlobalVars.playerSavedPosition = [100, 0]
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Node2D.tscn")


func _on_QuitToMain_pressed():
	get_tree().paused = false
	GlobalVars.playerSavedPosition = [100, 0]
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/MainMenu.tscn")

