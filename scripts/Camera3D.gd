extends Camera3D

var zoomSpeed: float = 2
var minZoom: float = 25.0
var maxZoom: float = 85.0
var dragSen: float = 2.0

var center: Vector3 = Vector3(1, 2, 2.5)
var zoom: float = 45

var mouse = Vector3()

var isHolding: bool = false
var time = 0

@onready var handlerResources = $"../HandleResources"
@onready var platform = $"../platform"

func _physics_process(delta):
	if isHolding:
		time += delta
		get_selected()
	else: 
		time = 0

func _input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		position -= Vector3(event.relative.x, 0, event.relative.y) * dragSen / fov * 0.1

	if event is InputEventMouseButton:
		mouse = event.position
		if event.button_index == MOUSE_BUTTON_LEFT:
			isHolding = event.pressed
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

func get_selected():
	var worldspace = get_world_3d().direct_space_state
	var start = project_ray_origin(mouse)
	var end = project_position(mouse, 1000)
	var result = worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(start, end))
	
	if result.has("collider"):
		if result["collider"] != platform:
			print(result["collider"])
			handlerResources.detect_object(result["collider"], time)
