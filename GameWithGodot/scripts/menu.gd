extends Node2D

# Process function
func _process(delta):
	# Changing scene when space or enter is press
	if Input.is_action_just_pressed("start_game"):
		get_tree().change_scene("res://Scenes/level1.tscn")
	# Closing the program
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
