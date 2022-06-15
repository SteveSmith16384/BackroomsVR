extends Spatial

onready var main = get_tree().get_root().get_node("Main")

var player
var wenv : WorldEnvironment
var env : Environment

func _ready():
	player = main.get_node("Player")
	wenv = main.get_node("WorldEnvironment")
	env = wenv.get_environment()
	pass


func _process(delta):
	var dist = player.translation.distance_to($DarknessCentre.global_transform.origin)
	if dist > 16:
		env.ambient_light_energy = 0.4
	else:
		var val = 0.4 * (dist/16)
		env.ambient_light_energy = val
		
	pass
