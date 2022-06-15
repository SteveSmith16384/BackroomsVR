extends Spatial



func _on_Timer_timeout():
	if Globals.rnd.randi_range(1, 4) > 1:
		return
		
	var idx = Globals.rnd.randi_range(1, 3)
	get_node("Audio3D_Robot" + str(idx)).play()
	pass

