extends CanvasLayer



func _on_Restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_Quit_pressed():
	get_parent().go_back_to_menu()
