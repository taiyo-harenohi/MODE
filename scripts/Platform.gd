extends Node3D

var probabilityDict = {
	"nothing": 6,
	"wood": 53,
	"water": 100,
}

var resourcesList = {}

@onready var _platform = $"ground"

func detect_colliders():
	var arrows_to_delete = []
	for _arrow in self.get_children():
		var nodes_in_group = get_tree().get_nodes_in_group("platform")
		for node in nodes_in_group:
			if _arrow.global_position.x == node.global_position.x and _arrow.global_position.z == node.global_position.z:
				arrows_to_delete.append(_arrow)
		nodes_in_group +=  get_tree().get_nodes_in_group("arrow")
		for node in nodes_in_group:
			if node.global_position == self.global_position:
				arrows_to_delete.append(node)
	for arrow_to_delete in arrows_to_delete:
		if arrow_to_delete.is_in_group("arrow"):
			arrow_to_delete.queue_free()

func generate_platforms():
	var rng = RandomNumberGenerator.new()
	var probability = rng.randf_range(1, 100)
	var type = ""

	if in_between(0, probabilityDict["nothing"], probability):
		print("generate nothing")	
	elif in_between(probabilityDict["nothing"], probabilityDict["wood"], probability):
		print("generate wood")
		type = "wood"
	elif in_between(probabilityDict["wood"], probabilityDict["water"], probability):
		print("generate water")
		type = "water"
		
	if type != "":
		generate_resources(type)
	
func in_between(minVal, maxVal, number) -> bool:
	if number > minVal && number < maxVal:
		return true
	return false

func generate_resources(type):
	var rng = RandomNumberGenerator.new()
	var probability = rng.randf_range(1, 4)
	
	var cube_scale = self.get_node("ground").scale
	var side_length = cube_scale.x 
	
	# TODO: load resource -- path the same, the end will be based on the type 
	var resource = load("res://scenes/wood.tscn")
	var i = 0
	while i < probability:
		var position_x = rng.randf_range(0, side_length)		
		var position_z = rng.randf_range(0, side_length)		
		
		var ground_position = _platform.global_transform.origin
		# TODO: not correct position
		var resource_position = ground_position + Vector3(position_x / cube_scale.x, cube_scale.y, position_z / cube_scale.z)
		

		var _instance = resource.instantiate()
		get_tree().get_root().add_child(_instance)
		_instance.transform.origin = resource_position
		
		_instance.connect("destroyResource", destroyResource)
		resourcesList[_instance.global_position] = _instance.position
		i += 1
	
func destroyResource(resource):
	if resource.global_position in _platform.resourcesList.keys():
		_platform.resourceList.remove(resource.global_position)
