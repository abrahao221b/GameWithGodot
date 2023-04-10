extends Node2D


# Process function
func _process(delta):
	# Restart
	if Input.is_action_just_pressed("restart"):
		Game.resetAll()
		get_tree().change_scene("res://Scenes/level1.tscn")
	# Closing the program
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
