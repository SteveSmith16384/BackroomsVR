extends Node

const VERSION = "0.2"
const RELEASE_MODE = false

const AUTOSTART = true and !RELEASE_MODE
const TEST_MODE = false and !RELEASE_MODE
#const NO_ENEMIES = false and !RELEASE_MODE
#const DISABLE_ATTACKS = false and !RELEASE_MODE
#const PLAYER_INVINCIBLE = false and !RELEASE_MODE

const SQ_SIZE = 4
const VIEW_RANGE = 50

#var WIDTH : int = 16
#var HEIGHT : int = 16

var next_nav_id : int = 0

var rnd : RandomNumberGenerator

func _ready():
	rnd = RandomNumberGenerator.new()
	rnd.randomize()
	pass
	

func reset():
	next_nav_id = 0
	pass
	

func apply_random_force(s:RigidBody, f:float):
	var x = rnd.randi_range(-1, 1)
	var y = rnd.randi_range(0, 1)
	var z = rnd.randi_range(-1, 1)
	var vec = Vector3(x, y, z)
	s.translation += vec*2
	s.apply_central_impulse(vec*f)
	s.apply_torque_impulse(vec)
	pass
	
