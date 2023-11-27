extends Camera3D

var zoomSpeed: float = 1
var minZoom: float = 25.0
var maxZoom: float = 65.0
var dragSen: float = 1.0

var center: Vector3 = Vector3(1, 2, 2.5)
var zoom: float = 45

func _input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		position -= Vector3(event.relative.x, 0, event.relative.y) * dragSen / fov * 0.1

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			fov -= zoomSpeed
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			fov += zoomSpeed
		fov = clamp(fov, minZoom, maxZoom)
	
	# TODO: maybe smoother motion to go back to the center
	if Input.is_action_just_pressed("to_center"):
		position = center
	if Input.is_action_just_pressed("restart_zoom"):
		fov = zoom
