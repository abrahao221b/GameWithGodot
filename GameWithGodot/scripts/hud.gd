extends CanvasLayer

# Constants
const PRE_ICON_BACKGROUND = preload("res://Scenes/heart1_background.tscn")
const PRE_ICON_FRONT = preload("res://Scenes/heart1_front.tscn")

# Function ready
func _ready():
	# Printing the player's hearts 
	for i in Game.heart:
		var icon_background = PRE_ICON_BACKGROUND.instance()
		var icon_front = PRE_ICON_FRONT.instance()
		$hbox_background.add_child(icon_background)
		$hbox_front.add_child(icon_front)
	
# Function Process
func _process(delta):
	$txt_life.text = "x" + " " + str(Game.life)
	$txt_points.text = str(Game.points)
	show_hearts_front()
	
# Function that verifies the quantity of hearts that should be shown
func show_hearts_front():
	for i in $hbox_front.get_child_count():
		$hbox_front.get_child(i).visible = Game.heart > i
	
