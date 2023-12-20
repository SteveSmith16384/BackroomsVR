extends Spatial

onready var main = get_tree().get_root().get_node("Main")

var rooms_created = {}

func _ready():
	load_room(Vector3())
	
	var cls = load("res://TeleportingBox.tscn")
	var box = cls.instance()
	self.add_child(box)
	pass
	
	
func load_room(pos: Vector3):
	if rooms_created.has(pos):
		#print("Room already exists")
		return
		
	var cls = load("Rooms/AbstractRoom.tscn") # todol - preload
	var room = cls.instance()
	room.spacestation = self
	room.translation = pos
	self.add_child(room)
	rooms_created[pos] = room
	
	main.log_debugging("Added room at " + str(pos))
	main.log_debugging("Total rooms: " + str(rooms_created.size()))
	
	pass


func remove_room(room):
	var pos = room.translation#.global_transform.origin
	main.log_debugging("Removing room at " + str(pos))
	var res = rooms_created.erase(pos)
	main.log_debugging("Total rooms: " + str(rooms_created.size()))
	if res == false:
		pass
	room.call_deferred("queue_free")
	pass
	
	
func player_n(from_room):
	var pos = from_room.translation
	pos.z += 32
	load_room(pos)
	pos.z += 32
	load_room(pos)
	pass
	
	
func player_s(from_room):
	var pos = from_room.translation
	pos.z -= 32
	load_room(pos)
	pos.z -= 32
	load_room(pos)
	pass
