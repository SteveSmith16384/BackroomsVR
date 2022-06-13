class_name Main
extends Spatial

var start_pos : Vector3

onready var camera = $ARVROrigin/ARVRCamera
onready var arvr = $ARVROrigin
onready var player = $Player
onready var players_head = $Player/Head

var log_lines = []
var game_is_over = true

var astar : AStar
var nav_points = []

onready var red_filter_mat: SpatialMaterial

func _ready():
	red_filter_mat = $ARVROrigin/ARVRCamera/RedFilter.get_active_material(0)

	arvr.translation = player.translation

	set_text("")
	
	if Globals.TEST_MODE:
		$ARVROrigin/LeftController/HandMesh.visible = false
		$ARVROrigin/RightController.visible = false
		
	load_scene("IntroScene")
	
	if Globals.AUTOSTART:
		yield(get_tree().create_timer(1), "timeout")
		start_game_proper()
	pass


func start_game_proper():
	Globals.reset()

	load_scene("Spacestation")
	
	game_is_over = false
	player.alive = true
	
	log_lines.clear()
	$Viewport/ConsoleLabel.text = ""
	pass
	
	
func load_scene(name:String):
	if $World.get_child_count() > 0:
		$World.remove_child($World.get_child(0))
	
	nav_points = []
	var scene = load("res://" + name + ".tscn").instance()
	$World.add_child(scene)
	start_pos = scene.get_node("StartPosition").global_transform.origin
	$Player.translation = start_pos
	pass

	
func _process(delta):
	if red_filter_mat.albedo_color.a > 0:
		red_filter_mat.albedo_color.a -= delta / 4
	pass
	
	
func _physics_process(delta:float):
	move_player(delta);
	arvr.translation = players_head.global_transform.origin
	pass
	

func move_player(_delta:float):
	if player.alive == false:
		player.move_dir = Vector3() # Cannot move if dead
		return
		
	var left_joy : Vector2 = arvr.left_joy_pos
	
	if Globals.TEST_MODE:
		left_joy.y = -1
		
	var cam_basis = camera.global_transform.basis
	var direction: Vector3 = Vector3.ZERO
	if left_joy.y != 0:
		direction = cam_basis.z * left_joy.y * -1
	if left_joy.x != 0:
		direction += cam_basis.x * left_joy.x

	direction.y = 0
	if direction.length() > 1:
		direction = direction.normalized()

	player.move_dir = direction
	pass
	

func set_text(s:String):
	$Viewport/ConsoleLabel.text = s
	pass
	
	
func log_debugging(s:String):
	if Globals.RELEASE_MODE:
		return
		
	log_text(s)
	pass


func log_text(s:String):
	print(s)
	log_lines.push_back(str(s))
	while log_lines.size() > 10:
		log_lines.remove(0)
		
	var text = ""
	for line in log_lines:
		text = text + line + "\n"
	$Viewport/ConsoleLabel.text = text
	pass


func player_killed():
	if $Player.alive == false:
		return
	
	if Globals.PLAYER_INVINCIBLE and $Player.translation.y > -3:
		return
		
	$Player.alive = false
	#$Player.get_node("Audio_Hit").play()

	red_filter_mat.albedo_color.a = 1

	yield(get_tree().create_timer(3), "timeout")

	start_game_proper()
	pass
	

func game_over():
	set_text("GAME OVER")
	game_is_over = true
	pass
	

func _on_LeftHandArea_area_entered(area):
	if area.is_in_group("touchable") == false:
		return
		
	var obj = area.get_parent()
	if obj != null:
		if obj.has_method("on_touch"):
			obj.on_touch()
	pass


func _on_LeftHandArea_area_exited(area):
	if area.is_in_group("touchable") == false:
		return
	pass


func can_see(from:Spatial, to:Spatial):
	var space_state = get_world().direct_space_state
	var result : Dictionary = space_state.intersect_ray(from.global_transform.origin, to.global_transform.origin)
	if result.size() > 0:
		if result.collider == to:
#			if result.collider.is_in_group("blocks_view"):
			return true
		else:
			return false
	return true
	
	
func left_button_pressed(button:int):
	if button == 4 or button == 5:
		self.log_text("Returning to lobby")
		call_deferred("load_scene", "IntroScene")
	pass
