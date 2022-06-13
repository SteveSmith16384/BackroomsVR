class_name Player
extends KinematicBody

const speed = 7
const gravity = 0.98

const laser_fire_rate = 0.2
const rocket_fire_rate = 1
const clip_size = 8
const laser_reload_rate = 0.8#1

var main #: Main

var alive = true

var move_dir: Vector3 #  Gets set by Main based on input
var current_fall_speed : float = 0
var is_on_floor = false
var play_footstep : bool = false
var actually_play_footstep : bool = true


func _ready():
	var shape:SphereShape = $Area/CollisionShape.shape
	shape.radius = Globals.VIEW_RANGE
	
	main = get_tree().get_root().get_node("Main")
	pass
	

func _physics_process(delta):
	self.current_fall_speed += gravity * delta
	
	if alive == false:
		var velocity = Vector3()
		velocity.x = 0
		velocity.z = 0
		velocity.y -= current_fall_speed
		var _unused = move_and_slide(velocity, Vector3.UP)
		return
		
	play_footstep = move_dir.length_squared() > 0

	move_dir.y -= current_fall_speed
	is_on_floor = false
	var _unused = move_and_slide(move_dir * speed, Vector3.UP)
	if get_slide_count() > 0:
		current_fall_speed = 0
		is_on_floor = true
		var coll = get_slide_collision(0).get_collider()
		if coll.has_method("collided"):
			coll.collided(self)
		pass
		
	if play_footstep && is_on_floor:
		play_footstep_sfx()
	
	pass
	

func play_footstep_sfx():
	if actually_play_footstep == false:
		return
		
	actually_play_footstep = false
	
	if Globals.rnd.randi_range(1, 2) == 1:
		$AudioStreamPlayer_Footstep1.play()
	else:
		$AudioStreamPlayer_Footstep2.play()
		
	yield(get_tree().create_timer(.45), "timeout")
	actually_play_footstep = true
	pass


#func restart(trans):
#	self.translation = trans
#	alive = true
#	pass
	
	
func _on_Area_body_entered(body):
	if "activated" in body:
		body.activated = true
	pass


func _on_Area_body_exited(body):
	if "activated" in body:
		body.activated = false
	pass
