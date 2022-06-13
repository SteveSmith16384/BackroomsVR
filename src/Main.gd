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

	load_astar()
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
		left_joy.y = 1
		
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
	

func fire_bullet(pos:Vector3, transform: Transform):
	player.fire_bullet(pos, transform)
	pass
	
	
func set_text(s:String):
	$Viewport/ConsoleLabel.text = s
	pass
	
	
func log_debugging(s:String):
	if Globals.RELEASE_MODE:
		return
		
	log_lines.push_back(str(s))
	while log_lines.size() > 12:
		log_lines.remove(0)
		
	var text = ""
	for line in log_lines:
		text = text + line + "\n"
	$Viewport/ConsoleLabel.text = text
	pass


func log_text(s:String):
	if Globals.RELEASE_MODE:
		return
		
	log_lines.push_back(str(s))
	while log_lines.size() > 6:
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

	$RestartTimer.start()
	red_filter_mat.albedo_color.a = 1
	pass
	
	
func _on_RestartTimer_timeout():
	#log_text("Restarting")
	$RestartTimer.stop()

	#$Player.restart(start_pos)
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


func exit_entered(entity):
	if entity == player:
		self.log_text("You have escaped!")
		call_deferred("load_scene", "IntroScene")
		pass
	pass
	

func load_astar():
	astar = AStar.new()

	for nav_point in nav_points:
		astar.add_point(nav_point.id, nav_point.global_transform.origin)
		
	for nav_point in nav_points:
		for other in nav_points:
			if nav_point == other:
				continue
			var dist = nav_point.global_transform.origin.distance_to(other.global_transform.origin)
			if dist > Globals.SQ_SIZE+1:
				continue
			if can_see(nav_point, other) == false:
				continue

			astar.connect_points(nav_point.id, other.id)

	pass
	

func get_final_dest() -> Vector3:
	var m = nav_points.size()
	var idx = Globals.rnd.randi_range(0, m-1)
	return nav_points[idx].global_transform.origin


func get_route(start:Vector3, end:Vector3):
	if astar == null:
		return [start]
	var id_from = astar.get_closest_point(start)
	var id_to = astar.get_closest_point(end)
	var r = astar.get_point_path(id_from, id_to)
	if r.size() == 0:
		print("Unable to get route!")
	return r
	

#func get_closest_point(pos: Vector3):
#	var disabled_points = []
#	var id_from
#	while true:
#		id_from = astar.get_closest_point(pos)
#		if nav_points[id_from].End_Point == false:
#			astar.set_point_disabled(id_from)
#			disabled_points.push_back(id_from)
#		else:
#			break;
#			
#	for p in disabled_points:
#		astar.set_point_disabled(p, false)
#		
#	return id_from
#	pass
	
	
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
