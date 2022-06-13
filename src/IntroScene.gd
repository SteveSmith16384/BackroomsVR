extends Spatial


onready var main = get_tree().get_root().get_node("Main")

func _process(delta):
	$MM_Floor.rotation_degrees.y += delta * 10
	$MM_Floor2.rotation_degrees.y += delta * 15
	$MM_Floor3.rotation_degrees.y += delta * 25
	pass
	

func _on_Area_Medium_body_entered(body):
	if body == main.player:
		Globals.WIDTH = 18
		Globals.HEIGHT = 18
		main.call_deferred("start_game_proper")
	pass
	

func _on_Area_Small_body_entered(body):
	if body == main.player:
		Globals.WIDTH = 14
		Globals.HEIGHT = 14
		main.call_deferred("start_game_proper")
	pass


func _on_Area_Large_body_entered(body):
	if body == main.player:
		Globals.WIDTH = 26
		Globals.HEIGHT = 26
		main.call_deferred("start_game_proper")
	pass
