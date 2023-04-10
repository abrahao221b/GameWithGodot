extends Node

# Variables 
var life = 1
var heart = 5
var points = 0
var bonus = 10

# Function that sum the points
func sumPoints(value):
	points += value

# Function that set the variable points to 0
func resetPoints():
	points = 0

# Function that decrements the player's life
func losesLife():
	life -= 1

# Function that decrements the player's hearts
func losesHearts(value):
	heart -= value

# Function that reset the hearts initial value
func resetHearts():
	heart = 5

# Function that reset the player's life quantity  
func resetLife():
	life = 1

# Function that reset bonus variable  
func resetBonus():
	bonus = 10

# Function that reset the quantity of everything
func resetAll():
	resetLife()
	resetHearts()
	resetPoints()
	resetBonus()

# Function that increase the quantity of life 
func win_life():
	if points >= bonus:
		life += 1
		bonus *= 2
	

