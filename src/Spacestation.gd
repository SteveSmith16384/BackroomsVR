extends Spatial

onready var main = get_tree().get_root().get_node("Main")

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
	
	main.log_debugging("Added room at " + str(pos))
	main.log_debugging("Total rooms: " + str(rooms_created.size()))
	
	return room


func remove_room(room):
	var pos = room.global_transform.origin
	main.log_debugging("Removing room at " + str(pos))
	rooms_created.erase(pos)
	main.log_debugging("Total rooms: " + str(rooms_created.size()))
	room.call_deferred("queue_free")
	pass
	
	
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
