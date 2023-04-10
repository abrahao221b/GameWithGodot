extends Sprite

# Constants 
const PRE_STONE = preload("res://Scenes/stone.tscn")

# Variables
var speed = 300
var instantiating = true 

# Fucntion ready
func _ready():
	pass

# Function process
func _process(delta):
	speed += 40
	# Pushing the fragement down 
	position.y += speed * delta
	
	# Calling the function stone_spawn after the fragment reaches a bigger range than 500
	if position.y > 500 and instantiating:
		stone_spawn()
		instantiating = false
	
	# Deleting the fragement when it reaches determine position
	if position.y > 900:
		queue_free()

# Function that's spawn a stone
func stone_spawn():
	var stone = PRE_STONE.instance()
	stone.position.x = position.x
	stone.position.y = -200
	get_parent().add_child(stone)
	
