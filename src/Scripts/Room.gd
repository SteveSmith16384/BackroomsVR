extends Node

var spacestation

func _ready():
	var rnd = Globals.rnd.randi_range(1, 4)
	var cls = load("Rooms/Room" + str(rnd) + ".tscn") # todol - preload
	var room = cls.instance()
	self.add_child(room)
	pass
	
	
