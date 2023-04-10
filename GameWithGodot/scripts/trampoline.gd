extends Area2D


func _ready():
	pass

# Trampoline jump function
func _on_trampoline_area_entered(area):
	area.get_parent().jump(2000, false)
	$animationTrampolin.play("trampoline")
