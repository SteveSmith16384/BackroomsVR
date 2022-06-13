extends Spatial

var start_pos
var middle_pos
var end_pos


func _ready():
	generate_maze()
	
	$StartPosition.translation.x = start_pos.x
	$StartPosition.translation.y = 1
	$StartPosition.translation.z = start_pos.y
	
	$Screenshot.translation.x = start_pos.x# - 0.5#1.9
	$Screenshot.translation.y = 1.7
	$Screenshot.translation.z = start_pos.y - 1.9
	
	if Globals.ZOMBIE:
		$Zombie.translation.x = middle_pos.x
		$Zombie.translation.z = middle_pos.y
		$RobotGeorge.queue_free()
	else:
		$RobotGeorge.translation.x = middle_pos.x
		$RobotGeorge.translation.z = middle_pos.y
		$Zombie.queue_free()

	$Exit.translation.x = end_pos.x
	$Exit.translation.z = end_pos.y
	
	if Globals.EXIT_CLOSE:
		$Exit.translation.x = start_pos.x + 2
		$Exit.translation.z = start_pos.y
		
	
	if Globals.NO_ENEMIES:
		$RobotGeorge.queue_free()
		$Zombie.queue_free()
	
	if Globals.mode == Globals.GameMode.CLASSIC:
		$Audio_Ambience.stop()
	else:
		$Audio_Ambience.play()
	pass


func generate_maze():
	var mg = Maze.new()
	mg.create_maze()
	
	var wall_class = preload("res://Wall2x2.tscn")
	var walkway_class = preload("res://Walkway2x2.tscn")
	
	var map = mg.map
	for y in mg.height:
		for x in mg.width:
			var section
			if map[x][y] == mg.WALL and Globals.OPEN_MAZE == false:
				section = wall_class.instance()
				#print("Added map at " + str(x) + "," + str(y))
			else:
				section = walkway_class.instance()

				if start_pos == null:
					start_pos = Vector2(x, y) * Globals.SQ_SIZE
				elif middle_pos == null and y > mg.height/2:
					middle_pos = Vector2(x, y) * Globals.SQ_SIZE
				elif end_pos == null and y > mg.height-4:
					end_pos = Vector2(x, y) * Globals.SQ_SIZE

			section.translation.x = x * Globals.SQ_SIZE
			section.translation.z = y * Globals.SQ_SIZE
			self.add_child(section)

	pass
