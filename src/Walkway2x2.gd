extends Spatial


func _ready():
	if Globals.mode == Globals.GameMode.CLASSIC:
		$Roof1_2x2.queue_free()
		$FloorBasic_2x2.queue_free()
	pass
