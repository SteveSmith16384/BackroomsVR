class_name Maze

const WALL = false
const PASSAGE = true

var map = [] # wall == false!
var width : int;
var height : int;


func _init():
	width = Globals.WIDTH
	height = Globals.HEIGHT
	pass
	
	
func create_maze():
#	if Globals.RELEASE_MODE == false:
#		width = 8
#		height = 8
	
	for h in height:
		var arr = []
		for w in width:
			arr.push_back(WALL)
		map.push_back(arr)
	
	var frontiers = []
	var x = Globals.rnd.randi_range(1, width-2);
	var y = Globals.rnd.randi_range(1, height-2);
	frontiers.push_back(Vector4.new(x, y, x, y))

	while frontiers.empty() == false:
		var idx = Globals.rnd.randi_range(0, frontiers.size()-1)
		var f = frontiers[idx]
		frontiers.remove(idx)
		x = f.x2
		y = f.y2
		#var tmp = map[x][y]
		if map[x][y] == WALL:
			map[f.x1][f.y1] = PASSAGE
			map[x][y] = PASSAGE
			if x >= 3 and map[x-2][y] == WALL:
				frontiers.push_back(Vector4.new(x-1,y,x-2,y))# new int[]{x-1,y,x-2,y} );
			if y >= 3 and map[x][y-2] == WALL:
				frontiers.push_back(Vector4.new(x,y-1,x,y-2))# new int[]{x,y-1,x,y-2} );
			if x < width-3 and map[x+2][y] == WALL:
				frontiers.push_back(Vector4.new(x+1,y,x+2,y))# new int[]{x+1,y,x+2,y} );
			if y < height-3 and map[x][y+2] == WALL:
				frontiers.push_back(Vector4.new(x,y+1,x,y+2))# new int[]{x,y+1,x,y+2} );
	
	#print_maze()
	pass
	

func print_maze():
	for y in height:
		var s:String
		for x in width:
			if map[x][y] == WALL:
				s = s + "W"
			else:
				s = s + "X"
		print(s)
	pass
	
	
class Vector4:

	var x1
	var y1
	var x2
	var y2

	func _init(_x1, _y1, _x2, _y2):
		x1 = _x1
		y1 = _y1
		x2 = _x2
		y2 = _y2
		pass
		
		
