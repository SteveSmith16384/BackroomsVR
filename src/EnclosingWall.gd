extends StaticBody

onready var main = get_tree().get_root().get_node("Main")

var player
var can_move = false

func _ready():
	player = main.get_node("Player")


func _process(delta):
	if can_move == false:
		return
		
	var diff = player.translation.x - self.global_transform.origin.x
	if abs(diff) > 10:
		diff = sign(diff)
		self.translation.x += diff * delta * 5
	pass


func _on_VisibilityNotifier_camera_entered(_camera):
	can_move = false
	pass


func _on_VisibilityNotifier_camera_exited(_camera):
	can_move = true
	pass
