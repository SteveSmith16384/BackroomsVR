extends Timer


func _on_RemoveAfterTime_timeout():
	get_parent().queue_free()
	pass
