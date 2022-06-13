extends CollisionShape


# Declare member va
func _ready():
	var mesh : MeshInstance = find_mesh()# self.get_parent().get_node("MeshInstance")
	var aabb: AABB = mesh.get_aabb()

	var box : BoxShape = BoxShape.new()
	box.extents.x = aabb.size.x/2
	box.extents.y = aabb.size.y/2
	box.extents.z = aabb.size.z/2
	self.shape = box

	self.translation.y = aabb.size.y/2 # Not sure why we only have to change the y?
	pass
	

func find_mesh() -> MeshInstance:
	for child in get_parent().get_children():
		if child is MeshInstance:
			return child
	push_error("No MeshInstance found")
	return null
