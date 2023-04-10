extends Area2D

# Variables
var speed = 300

# Function ready
func _ready():
	pass

# Function process
func _process(delta):
	speed += 40
	# Pushing the stone down 
	position.y += speed * delta
	
	# Deleting the stone when it reaches determine position
	if position.y > 900:
		queue_free()

# Stone and player interaction
func _on_stone_body_entered(body):
	if body.position.x < position.x:
		body.hitted(-800, 2)
		Sounds.play_impact()
	else:
		body.hitted(800, 2)
		Sounds.play_impact()
