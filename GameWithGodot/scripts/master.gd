extends KinematicBody2D

# Constants 
const GRAVITY = 4000
const PRELOAD_FRAGMANT = preload("res://Scenes/fragment.tscn")
const PRE_ICON_BACKGROUND = preload("res://Scenes/heart1_background.tscn")
const PRE_ICON_FRONT = preload("res://Scenes/heart1_front.tscn")

# Variables 
var velocity = Vector2(0,0) 
var speed = 300

# Will state the set of actions the boss will take
var state = 1 
# Boss behavior according to the given state
var behavior = 0

# Setting a timer to change the boss behavior
var behavior_time = 0
# Setting a period to track the boss walk action 
var period = 0

# Tracking to where the level boss is looking
var direction = -1

# Player and master interaction 
var active_master = false
var hit = false
var life = 10
var dead = false
var master_show_background_life = true

# Timer
var time = null

func _ready():
	randomize()
	pass
	
func _process(delta):
	# Setting gravity for the boss 
	velocity.y += GRAVITY * delta
	
	# The following code will be compile only if the boss got life 
	if life >= 1 and active_master:
		# The following code will only be compiled if the boss has not been hitted
		if !hit:
			# Setting which behavior the boss will take
			if state == 1:
				if behavior == 0:
					idle(delta)
				if behavior == 1:
					walk()
			else:
				if behavior == 0:
					idle(delta)
				if behavior == 1:
					running()
				if behavior == 2:
					fury()
	if life < 1 and active_master:
		$animationMaster.play("die")
		velocity.x = 0
		active_master = false
		dead = true
		$"../player".stage_clear = true
		Game.sumPoints(100)
		Game.sumPoints(Game.heart*10 + Game.life*2)
		Sounds.play_you_win()
		yield(get_tree().create_timer(7), "timeout")
		get_tree().change_scene("res://Scenes/youWin.tscn")	
		
		
		
		
	# Boss movement   
	velocity = move_and_slide(velocity, Vector2.UP, true)
	
	# Changing the shadow visibility to true when the level boss is on floor
	if is_on_floor():
		$boss_shadow.visible = true
	# Second boss state after loses some life 
	if life < 8:
		state = 2
	
	# Printing the hearts modification
	show_hearts_front()
	
# Function idle
func idle(delta):
	$animationMaster.play("idle")
	velocity.x = 0
	behavior_time += delta
	if behavior_time > 5:
		behavior_time = 0
		if state == 1:
			behavior = 1
		else:
			behavior = int(rand_range(1, 3))

# Character moving function
func moving(limit_max):
	# The boss only walks or runs if the period is less than 2
	if period < 2:
		if direction == -1:
			velocity.x = -speed * limit_max
		if direction == 1:
			velocity.x = speed * limit_max
		# Changing the boss walking or running direction when it reaches the environment position limit
		if position.x <= $"../master_walk_limit/left".position.x:
			if direction == -1:
				direction = 1
				period += 1
				flip()
		if position.x >= $"../master_walk_limit/right".position.x:
			if direction == 1:
				direction = -1
				period += 1
	else:
		behavior_back()
		period = 0
		flip()	
	
	
# Function that calls the walking action
func walk():
	$animationMaster.play("walk")
	moving(1)

# Function that calls the running action
func running():
	$animationMaster.play("running")
	moving(2)

# Function that calls the fury action
func fury():
	Sounds.play_boss_fury()
	$animationMaster.play("fury")
	
# Jumping function
func jump():
	velocity.y = -1000
	$boss_shadow.visible = false

# Assigning the behavior to 0
func behavior_back():
	behavior = 0

# Calling the shaking action on the player's camera
func call_camera_shake():
	$"../player/cam_animation".play("shake")

# Function that flips the boss's image, when it turns the direction 
func flip():
	scale.x *= -1
	
# Function that treats the player and boss interaction
func _on_boss_head_area_area_entered(area):
	if active_master:
		hitted()
		Sounds.play_impact()
		area.get_parent().jump(1200, true)
		if state == 1:
			$animationMaster.play("hit_walk")
			velocity.x = 0
		else:
			if behavior == 1:
				$animationMaster.play("hit_walk")
			else:
				$animationMaster.play("hit_running")
				velocity.x = 0	
	
# Function that decreases the master life when it was hitted by the player 
func hitted():
	hit = true
	life -= 1
	
# Function that ends the hit state 
func end_hit():
	hit = false

# Master and player interaction
func _on_boss_body_area_body_entered(body):
	if Game.life > 0: 
		if active_master:
			if body.position.x < position.x:
				Sounds.play_impact()
				body.hitted(-1000, 2)
			else:
				Sounds.play_impact()
				body.hitted(1000, 2)

# Master's area and player camera interaction
func _on_notifier_screen_entered():
	if !dead: 
		# Printing the master's hearts
		if master_show_background_life:
			for i in $"../master".life:
				var icon_background_master = PRE_ICON_BACKGROUND.instance()
				var icon_front_master = PRE_ICON_FRONT.instance()
				$"../hud/hbox_background_master".add_child(icon_background_master)
				$"../hud/hbox_front_master".add_child(icon_front_master)
			master_show_background_life = false
		active_master = true

# Call fragment function
func fragment_spawn():
	fragment()
	
# Instantiating fragment after boss fury action
func fragment():
	for i in range(5):
		var pre_fragment = PRELOAD_FRAGMANT.instance()
		pre_fragment.position.x = position.x - 300 * (i + 1) 
		pre_fragment.position.y = -200
		get_parent().add_child(pre_fragment)

# Function that verifies the quantity of hearts that should be shown
func show_hearts_front():
	for i in $"../hud/hbox_front_master".get_child_count():
		$"../hud/hbox_front_master".get_child(i).visible = life > i
		
# Call boss walking sound
func boss_walking_sound():
	Sounds.play_impact()
	
# Call boss running sound
func call_boss_running_sound():
	Sounds.play_boss_running()
