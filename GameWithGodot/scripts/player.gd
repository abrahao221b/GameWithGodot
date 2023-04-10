extends KinematicBody2D

# Constants
const GRAVITY = 4000 

# Variables
var velocity = Vector2.ZERO		# Player velocity. In the beginning (0, 0)
var speed_max = 600			# Player maximum speed

# Player jump action
#var jump_force = 1200 
var is_jump = false
var jump_count = 2
var was_falling = false

# Camera
var master_room = false
var zoom = 1.2
var time = 0
var open_count = false

# Camera offset
var offset_cam = 0
var offset_max_value = 280

# Player hit
var hit = false

# Player state
var dead = false

# Player end game
var in_game = true
var stage_clear = false
var control = true
var falls = 0

# Start game sound
var start_game = true

# Main function
func _ready():
	Sounds.play_background_sound()
	if start_game:
		Sounds.play_start_game()
		start_game = false
	pass

# Process function
func _process(delta):
	if position.y >= 600:
		Sounds.play_fall_in_the_river()
		get_tree().reload_current_scene()
		Game.resetPoints()
		Game.resetBonus()
		Game.resetLife()
		hitted(0, 1)
	# Limiting the camera position
	$cam.limit_left = $"../initial_position".position.x
	$cam.limit_right = $"../final_position".position.x
	
	# Gravity Application
	velocity.y += 	GRAVITY * delta
	
	# Zoom implementation
	if open_count:
		time += delta
		if time > 1:
			master_room = true
			$"../initial_position".position.x = $"../limit_left".position.x - 750
			open_count = false
			
	# Changing the camera position on the master's room
	if master_room:
		zoom = lerp(zoom, 1.5, 0.05)
	else:
		zoom = lerp(zoom, 1.2, 0.05)
	$cam.zoom = Vector2(zoom, zoom)
	
	# Defining player direction
	var direction = 0 
	if control:
		direction = Input.get_axis("left", "right")
	
	# Gradually increasing player velocity 
	if direction != 0 and !hit:
		velocity.x = lerp(velocity.x, direction * speed_max, 0.1)
	else:
		if is_on_floor():
			velocity.x = lerp(velocity.x, 0, 0.2)
		else:
			velocity.x = lerp(velocity.x, 0, 0.001)
	
	# Camera offset
	if direction != 0:
		if $sprite.flip_h: # If player is looking to the right
			offset_cam = lerp(offset_cam, offset_max_value, 0.03)
		else: # If player is looking to the left
			offset_cam = lerp(offset_cam, -offset_max_value, 0.03)
			
	$cam.offset.x = offset_cam
	
	# Actions that only happens if the player is on the floor
	if is_on_floor() and !hit and Game.life > 0:
		$shadow.visible = true
		#is_jump = false, implementing only one jump
		jump_count = 2
		
		# Changing player's sprite direction
		if direction > 0:
			$sprite.flip_h = true
		if direction < 0:
			$sprite.flip_h = false
		
		if was_falling:
			$animation.play("jump3")
		else:
			# Player animation
			if direction != 0:
				$animation.play("running")
			else:
				Sounds.stop_running()
				$animation.play("idle")
	else:
		was_falling = true
		
	# Player Jumpping
	if Input.is_action_just_pressed("jump") and jump_count > 0 and !hit and Game.life > 0 and control:
		#is_jump = true, implementing only one jump
		jump_count -= 1
		jump(1200, true)
	
	# Dust emission function
	if is_on_floor() and direction != 0 and Game.life > 0 and control: 
		$dust.emitting = true
	else:
		$dust.emitting = false
	
	# Movement
	if Game.life > 0 and control:
		velocity = move_and_slide(velocity, Vector2.UP, true)
	
	# Player's die animation
	if !Game.life > 0 and dead:
		die()
	
	if is_on_floor() and stage_clear:
		control = false
	
# Function for the first part of the action jump 
func jump(jump_force, have_sound):
	Sounds.stop_running()
	$animation.play("jump1")
	if have_sound:
		Sounds.play_jump_voice()
	$shadow.visible = false
	velocity.y = -jump_force
	hit = false
	
	
# Function for the second part of the action jump
func jump2():
	$animation.play("jump2")

func is_falling():
	was_falling = false

# Zoom out on the master's area
func _on_limit_left_body_entered(body):
	if body.name == "player":
		open_count = true

# The function implements the player behavior after enemy attack
func hitted(force, value):
	hit = true
	$animation.play("hit")
	velocity.x = force
	velocity.y = -800
	$shadow.visible = false
	# Verifying the player's state
	if Game.heart > 1:
		Game.losesHearts(value)
	else:
		Game.losesLife()
		if !Game.life > 0:
			Game.losesHearts(value)
			dead = true
			Sounds.play_you_lose()
			print("Game Over!")
		else:
			Game.resetHearts()
		
	

# Ends the hit action on the player
func end_hit():
	hit = false

# Function that plays the die animation
func die():
	$animation.play("die")
	dead = false
	yield(get_tree().create_timer(4), "timeout")
	get_tree().change_scene("res://Scenes/youLoose.tscn")

# Call player's running sound
func call_player_running_sound():
	Sounds.play_running()
