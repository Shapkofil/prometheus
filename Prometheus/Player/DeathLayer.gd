extends CanvasLayer



func _on_Restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_Quit_pressed():
	get_tree().paused = false
	for child in get_tree().get_root().get_children():
		print(child.get_name())
		if "fireball" in child.get_name() or "lightning" in child.get_name():
			child.queue_free()
	get_tree().change_scene("res://UI/MainMenu.tscn")
