extends Node2D

# Play sounds functions 

func play_crystal():
	$crystal.play()

func play_impact():
	$impact.play()

func play_background_sound():
	$background_sound.play()

func play_boss_fury():
	$boss_fury.play()
	
func play_fall_in_the_river():
	$fall_in_the_river.play()
	
func play_jump_voice():
	$jump_voice.play()
	
func play_running():
	$running.play()
	
func play_start_game():
	$start_game.play()
	
func play_you_lose():
	$you_lose.play()

func play_boss_running():
	$boss_running.play()
	
func play_you_win():
	$you_win.play()
	
# Stop sounds functions

#func stop_crystal():
#	$crystal.stop()
#
#func stop_impact():
#	$impact.stop()
#
#func stop_background_sound():
#	$background_sound.stop()
#
#func stop_boss_fury():
#	$boss_fury.stop()
#
#func stop_fall_in_the_river():
#	$fall_in_the_river.stop()
#
#func stop_jump_voice():
#	$jump_voice.stop()
	
func stop_running():
	$running.stop()
	
#func stop_start_game():
#	$start_game.stop()
#
#func stop_you_lose():
#	$you_lose.stop()
