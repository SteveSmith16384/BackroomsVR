extends Position3D

onready var main = get_tree().get_root().get_node("Main")

var id
var pos : Vector3

func _ready():
	id = Globals.next_nav_id
	Globals.next_nav_id += 1
	
	pos = self.global_transform.origin
	
	if main:
		main.nav_points.push_back(self)

	self.translation.y = 1 # So we're not under the floor
	
#	yield(get_tree().create_timer(1), "timeout")
		
#	var crate_class = preload("res://Scenery/Crate1.tscn")
#	var crate = crate_class.instance()
#	crate.translation = self.global_transform.origin
#	crate.translation.y = 3
#	main.add_child(crate)
	#crate.apply_central_impulse(Vector3(40, 0, 0))
	pass
	
	
#func can_see(p):
#	return main.can_see(self, p)

