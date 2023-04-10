extends KinematicBody2D

# Constants 
const GRAVITY = 4000
const PRE_EXPLOSION = preload("res://Scenes/explosion.tscn")

# Variables
var velocity = Vector2.ZERO
var vel_max = 300
export(int, "left", "right") var direction
export(int, "type idle", "type walk") var type
var hitted = false

# Main function of the node enemy
func _ready():
	# Changing enemy's sprite direction and fixing enemy collision area direction
	if direction == 0: # The enemy is looking for the left
		$enemy_img.scale.x = 1
		$enemy_area/head_shape.position.x *= 1
		# Putting RayCast arrow to the right position
		$ray.position.x *= 1
	else: # The enemy is looking for the right
		$enemy_img.scale.x = -1
		$enemy_area/head_shape.position.x *= -1
		# Putting RayCast arrow to the left position
		$ray.position.x *= -1
	

# Process function
func _process(delta):
	# Applying gravity for the enemy character
	velocity.y += GRAVITY * delta
	
	if type == 0 and !hitted: # If is a sprite of the type idle, and the enemy character was not hitted
		vel_max = 0
		$animation.play("idle")
	else: # Sprite type walk
		# The enemy will keep walking if the RayCast node is colliding
		if $ray.is_colliding():
			if direction == 0: # Enemy is walking to the left
				vel_max = -200
			else: # Enemy is walking to the right
				vel_max = 200
		# The enemy will change the direction if the RayCast node stop to collide
		else:
			$ray.position.x *= -1
			# Changing the enemy direction to the right 
			if direction == 0:
				direction = 1
				$enemy_area/head_shape.position.x *= -1
				$enemy_img.scale.x *= -1
			# Changing the enemy direction to the left
			else:
				direction = 0
				$enemy_area/head_shape.position.x *= -1
				$enemy_img.scale.x *= -1
		velocity.x = vel_max
	
	# The enemy will move only if not hitted
	if !hitted:
		# Movement
		velocity = move_and_slide(velocity, Vector2.UP, true)

# The function will be call when the enemy area is in contact with the player area
func _on_enemy_area_area_entered(area):
	# Forcing the player to jump over the enemy automatically
	area.get_parent().jump(1200, true)
	change_hitted()
	# Changing the enemy's layer after player hit it
	$enemy_area.collision_layer = 1
	# Calling the method explosion after enemy die
	explosion()
	Game.sumPoints(3)

# Enemy hit
func change_hitted():
	hitted = true
	$animation.play("hit")
	Sounds.play_impact()

# Creating an instance of the explosion scene and setting it inside the main scene
func explosion():
	var explosion = PRE_EXPLOSION.instance()  
	explosion.emitting = true
	explosion.get_node("explosion").emitting = true
	explosion.global_position = global_position
	get_parent().add_child(explosion)

# The function deletes the enemy dead
func deleting_enemy():
	queue_free()

# Enemy hitting on the player
func _on_enemy_area_body_entered(body):
	if Game.life > 0:
		# Player is on the left side
		if body.position.x < position.x:
			Sounds.play_impact()
			body.hitted(-800, 1)
		# Player is on the right side
		else:
			Sounds.play_impact()
			body.hitted(800, 1)
		
