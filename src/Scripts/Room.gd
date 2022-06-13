extends Node

var spacestation

func _ready():
	var cls = load("Rooms/Room1.tscn") # todol - preload
	var room = cls.instance()
	self.add_child(room)
	pass
	
	
