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


func _on_RestartLevel_pressed():
	
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()


func _on_QuitToMain_pressed():
	get_parent().go_back_to_menu()

