extends Spatial

onready var main = get_tree().get_root().get_node("Main")

var node_left
var seen = false

func _ready():
	node_left = main.find_node("Position3D_Left")
	teleport()
	pass
	
	
func _process(_delta):
#	teleport()
	pass
	
	
func _on_VisibilityNotifier_camera_entered(_camera):
	seen = true
	pass


func _on_VisibilityNotifier_camera_exited(_camera):
	if seen:
		teleport()
		seen = false
	pass


func teleport():
	var pos = node_left.global_transform.origin
	self.translation = pos
	pass
	
