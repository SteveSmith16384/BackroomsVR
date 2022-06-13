extends Spatial
 
var webxr_interface
var vr_supported = false

onready var main = get_tree().get_root().get_node("Main")

var left_joy_pos : Vector2 = Vector2()
var right_joy_pos : Vector2 = Vector2()

func _ready() -> void:
	$ARVRCamera.far = Globals.VIEW_RANGE
	 
	webxr_interface = ARVRServer.find_interface("WebXR")
	if webxr_interface:
		# WebXR uses a lot of asynchronous callbacks, so we connect to various
		# signals in order to receive them.
		webxr_interface.connect("session_supported", self, "_webxr_session_supported")
		webxr_interface.connect("session_started", self, "_webxr_session_started")
		webxr_interface.connect("session_ended", self, "_webxr_session_ended")
		webxr_interface.connect("session_failed", self, "_webxr_session_failed")
 
		webxr_interface.connect("select", self, "_webxr_on_select")
		webxr_interface.connect("selectstart", self, "_webxr_on_select_start")
		webxr_interface.connect("selectend", self, "_webxr_on_select_end")
 
		webxr_interface.connect("squeeze", self, "_webxr_on_squeeze")
		webxr_interface.connect("squeezestart", self, "_webxr_on_squeeze_start")
		webxr_interface.connect("squeezeend", self, "_webxr_on_squeeze_end")
 
		# This returns immediately - our _webxr_session_supported() method 
		# (which we connected to the "session_supported" signal above) will
		# be called sometime later to let us know if it's supported or not.
		webxr_interface.is_session_supported("immersive-vr")
 
	var _unused1 = $LeftController.connect("button_pressed", self, "_on_LeftController_button_pressed")
	var _unused2 = $LeftController.connect("button_release", self, "_on_LeftController_button_release")

	var _unused3 = $RightController.connect("button_pressed", self, "_on_RightController_button_pressed")
	var _unused4 = $RightController.connect("button_release", self, "_on_RightController_button_release")
	pass
	

func _webxr_session_supported(session_mode: String, supported: bool) -> void:
	if session_mode == 'immersive-vr':
		vr_supported = supported
 

func _on_Button_pressed() -> void:
	if not vr_supported:
		OS.alert("Your browser doesn't support VR")
		return
 
	# We want an immersive VR session, as opposed to AR ('immersive-ar') or a
	# simple 3DoF viewer ('viewer').
	webxr_interface.session_mode = 'immersive-vr'
	# 'bounded-floor' is room scale, 'local-floor' is a standing or sitting
	# experience (it puts you 1.6m above the ground if you have 3DoF headset),
	# whereas as 'local' puts you down at the ARVROrigin.
	# This list means it'll first try to request 'bounded-floor', then 
	# fallback on 'local-floor' and ultimately 'local', if nothing else is
	# supported.
	webxr_interface.requested_reference_space_types = 'bounded-floor, local-floor, local'
	# In order to use 'local-floor' or 'bounded-floor' we must also
	# mark the features as required or optional.
	webxr_interface.required_features = 'local-floor'
	webxr_interface.optional_features = 'bounded-floor'
 
	# This will return false if we're unable to even request the session,
	# however, it can still fail asynchronously later in the process, so we
	# only know if it's really succeeded or failed when our 
	# _webxr_session_started() or _webxr_session_failed() methods are called.
	if not webxr_interface.initialize():
		OS.alert("Failed to initialize")
		return
	pass
	
	
func _webxr_session_started() -> void:
	$Button.visible = false
	# This tells Godot to start rendering to the headset.
	get_viewport().arvr = true
	# This will be the reference space type you ultimately got, out of the
	# types that you requested above. This is useful if you want the game to
	# work a little differently in 'bounded-floor' versus 'local-floor'.
	log_text("Reference space type: " + webxr_interface.reference_space_type)
	pass
	
	
func _webxr_session_ended() -> void:
	$Button.visible = true
	# If the user exits immersive mode, then we tell Godot to render to the web
	# page again.
	get_viewport().arvr = false
	pass
	
	
func _webxr_session_failed(message: String) -> void:
	OS.alert("Failed to initialize: " + message)
	pass
	
	
func _on_LeftController_button_pressed(button: int) -> void:
	log_text ("Left Button pressed id: " + str(button))
	main.left_button_pressed(button)
	pass
	
	
func _on_LeftController_button_release(button: int) -> void:
	log_text ("Left Button release id: " + str(button))
	pass
	
	
func _on_RightController_button_pressed(button: int) -> void:
	log_text ("Right Button pressed id: " + str(button))
	if button == 0:
		main.fire_bullet($RightController/gun/Muzzle.global_transform.origin, $RightController.global_transform)
	elif button == 1:
#		main.fire_rocket($ARVRCamera/RocketMuzzle.global_transform.origin, $RightController.global_transform)
		main.fire_rocket($RightController/gun/Muzzle.global_transform.origin, $RightController.global_transform)
	pass
	
	
func _on_RightController_button_release(button: int) -> void:
	log_text ("Right Button release id: " + str(button))
	pass
	
	
func _process(_delta: float) -> void:
	pass
	
	
func _input(event):
	if event is InputEventJoypadMotion:
		var joystick_event: InputEventJoypadMotion = event
		if event.device == $LeftController.get_joystick_id():
			#log_text("_input: Left joystick! " + event.as_text())
			if joystick_event.axis == 2:
				left_joy_pos.x = joystick_event.axis_value
			else:
				left_joy_pos.y = joystick_event.axis_value
			pass
		if event.device == $RightController.get_joystick_id():
			#log_text("_input: Right joystick! " + event.as_text())
			if joystick_event.axis == 2:
				right_joy_pos.x = joystick_event.axis_value
			else:
				right_joy_pos.y = joystick_event.axis_value
			pass
	pass
	
	
func _webxr_on_select(controller_id: int) -> void:
	log_text("Select controller id: " + str(controller_id))
 
	var controller: ARVRPositionalTracker = webxr_interface.get_controller(controller_id)
	log_text(controller.get_orientation())
	log_text(controller.get_position())
	pass
	
	
func _webxr_on_select_start(controller_id: int) -> void:
	log_text("Select Start id: " + str(controller_id))
	pass
	
	
func _webxr_on_select_end(controller_id: int) -> void:
	log_text("Select End controller id: " + str(controller_id))
	pass
	
	
func _webxr_on_squeeze(controller_id: int) -> void:
	log_text("Squeeze controller id: " + str(controller_id))
	pass
	
	
func _webxr_on_squeeze_start(controller_id: int) -> void:
	log_text("Squeeze Start; controller id: " + str(controller_id))
	pass
	
	
func _webxr_on_squeeze_end(controller_id: int) -> void:
	log_text("Squeeze End; controller id: " + str(controller_id))
	pass
	

func log_text(s):
	print(s)
	#main.log_text(s)
	pass
