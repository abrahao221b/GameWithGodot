extends Area2D

# Variables
var point = 1

# Function ready
func _ready():
	pass

# Function that treats the interaction player and crystal 
func _on_crystal_body_entered(body):
	Sounds.play_crystal()
	Game.sumPoints(point)
	Game.win_life()
	queue_free()
