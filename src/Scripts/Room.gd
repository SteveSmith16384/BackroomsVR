extends Node

var spacestation

func _ready():
	var cls
	if Globals.TEST_ROOM:
		cls = load("Rooms/" + Globals.TEST_ROOM_NAME + ".tscn")
	else:
		var rnd = Globals.rnd.randi_range(1, 5)
		cls = load("Rooms/Room" + str(rnd) + ".tscn") # todol - preload
	var room = cls.instance()
	self.add_child(room)
	pass
	
	
