extends Node

onready var main = get_tree().get_root().get_node("Main")


func _on_Area_Remove_body_exited(body):
	if body.is_in_group("Player"):
		var room = get_parent()
		get_parent().spacestation.remove_room(room)
		pass
	pass


func _on_Area_Add_body_entered(body):
	if body.is_in_group("Player"):
		var room = get_parent()
		get_parent().spacestation.player_n(room)
		get_parent().spacestation.player_s(room)
	pass
