extends Spatial

var rooms_created = {}

func _ready():
	load_room(Vector3())
	pass
	
	
func load_room(pos: Vector3):
	var cls = load("Rooms/Room1.tscn")
	var room = cls.instance()
	room.spacestation = self
	room.translation = pos
	self.add_child(room)
	rooms_created[pos] = room
	return room


func player_n(from_room):
	var pos = from_room.translation
	pos.z -= 24
	if rooms_created.has(pos) == false:
		load_room(pos)
	pass
	
	
func player_s(from_room):
	var pos = from_room.translation
	pos.z += 24
	if rooms_created.has(pos) == false:
		load_room(pos)
	pass
