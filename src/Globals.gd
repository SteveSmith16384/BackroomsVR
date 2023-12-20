extends Node

const VERSION = "0.2"
const RELEASE_MODE = false

const AUTOSTART = true and !RELEASE_MODE
const TEST_ROOM = false and !RELEASE_MODE
const TEST_ROOM_NAME = "DarkRoom"
const TEST_MODE = false and !RELEASE_MODE

const SQ_SIZE = 4
const VIEW_RANGE = 90

var rnd : RandomNumberGenerator

func _ready():
	rnd = RandomNumberGenerator.new()
	rnd.randomize()
	pass
	

func reset():
	pass
	
