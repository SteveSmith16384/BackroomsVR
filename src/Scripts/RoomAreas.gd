extends Node


func _on_Area_Remove_body_exited(body):
	if body.is_in_group("Player"):
		call_deferred("queue_free")
		pass
	pass


func _on_Area_N_body_entered(body):
	if body.is_in_group("Player"):
		get_parent().spacestation.player_n(get_parent())
	pass


func _on_Area_S_body_entered(body):
	if body.is_in_group("Player"):
		get_parent().spacestation.player_s(get_parent())
	pass
