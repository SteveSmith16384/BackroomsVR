extends KinematicBody

const speed = 60
const gravity = 0.7

onready var main = get_tree().get_root().get_node("Main")

var walk_anim : AnimationPlayer
var fury_anim : AnimationPlayer
var space_state
var player
var player_in_field = false
var can_see_player = false
var can_attack_player = false
var fury_mode = true

var route = []

func _ready():
	space_state = get_world().direct_space_state

	walk_anim = get_node("ZombieWalkingModel/AnimationPlayer")
	walk_anim.current_animation = "Take 001"
	walk_anim.playback_speed = 1
	#walk_anim.play()

	fury_anim = get_node("ZombieFuryModel/AnimationPlayer")
	fury_anim.current_animation = "Take 001"
	fury_anim.playback_speed = 1

	player = main.get_node("Player")
	
	start_walk_mode()
	pass


func _process(delta):
	if Globals.DISABLE_ZOMBIE:
		return
		
	# Gravity
	var vec3 = Vector3.ZERO
	vec3.y = -gravity
	var _unused = move_and_slide(vec3, Vector3.UP)

	if player.alive == false:
		return
		
	if fury_mode:
		pass
	else:
		walk_anim.play()
		
	var target_point:Vector3
	if can_see_player:
		start_walk_mode()
		#look_at(player.global_transform.origin, Vector3.UP)
		turn_towards(player.global_transform.origin, delta)
		target_point = player.global_transform.origin
		route = PoolVector3Array([target_point])
	else:
		if fury_mode:
			return
		if route.empty():
			var final_dest:Vector3 = get_final_dest()
			route = main.get_route(self.global_transform.origin, final_dest)
			return
		else:
			var target = route[0]
			target.y = self.global_transform.origin.y
			if target.distance_to(self.global_transform.origin) < 1:
				route.remove(0)
				if route.size() == 0:
					start_fury_mode()
				return
			else:
				target.y = self.translation.y
				#look_at(target, Vector3.UP)
				turn_towards(target, delta)
				target_point = route[0]

	move_to_target(target_point, delta)
	pass


func turn_towards(them:Vector3, delta):
	var us = self.translation
	var wtransform = global_transform.looking_at(Vector3(them.x,us.y,them.z),Vector3(0,1,0))
	var wrotation = Quat(global_transform.basis).slerp(Quat(wtransform.basis), delta*5)
	self.global_transform = Transform(Basis(wrotation), global_transform.origin)
	pass
	
	
func get_final_dest():
	return main.get_final_dest()
	
	
func move_to_target(target:Vector3, delta):
	var direction = (target - global_transform.origin).normalized()
	var _unused = move_and_slide(direction * speed * delta, Vector3.UP)
	if _unused.length() < 0.01:
		route = PoolVector3Array()
	pass
	

func _on_Timer_timeout():
	var id = Globals.rnd.randi_range(1, 24)
	var sfx = load("res://Assets/sfx/zombies/zombie-" + str(id) + ".wav")
	$AudioStreamPlayer3D.stream = sfx
	$AudioStreamPlayer3D.play()

	$Timer_Sfx.wait_time = Globals.rnd.randi_range(10, 15)
	pass


func _on_Timer_SeePlayer_timeout():
	if player.alive == false:
		return
		
	if can_attack_player:
		start_walk_mode()
		player.harmed(0.5)
		return
		
	can_see_player = false

	if player_in_field:
		var player_pos = player.first_person_camera.global_transform.origin
		player_pos.y += 1
		var result : Dictionary = space_state.intersect_ray($Position3D_Eyes.global_transform.origin, player_pos)
		if result.size() > 0:
			if result.collider.is_in_group("player"):
				start_walk_mode()
				can_see_player = true
			else:
				#print("Something in the way")
				pass
		else:
			print("No results")
	else:
		#print("Play no longer in field")
		pass
		
#	print("Can see player: " +str(can_see_player))
	pass


func start_walk_mode():
#	walk_anim.play()
	if fury_mode == false:
		return
	fury_mode = false
	$Timer_EndFury.stop()
	$ZombieFuryModel.visible = false
	$ZombieWalkingModel.visible = true
	pass
	

func start_fury_mode():
	if fury_mode:
		return
	fury_mode = true
	$ZombieFuryModel.visible = true
	$ZombieWalkingModel.visible = false
	fury_anim.play()
	$Timer_EndFury.start()
	pass
	

func _on_Area_See_body_entered(body):
	if body == player:
		player_in_field = true
	pass


func _on_Area_See_body_exited(body):
	if body == player:
		player_in_field = false
	pass


func _on_Area_Attack_body_entered(body):
	if body == player:
		can_attack_player = true
	pass


func _on_Area_Attack_body_exited(body):
	if body == player:
		can_attack_player = false
	pass


func _on_Timer_EndFury_timeout():
	self.start_walk_mode()
	pass
