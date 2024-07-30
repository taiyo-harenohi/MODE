extends Node3D

var probabilityDict = {
	"nothing": 6,
	"wood": 53,
	"water": 100,
	"stone": 0,
	"coal": 0,
	"gems": 0,
	"iron": 0,
	"meat": 0,
	"people": 0,
}

var resourcesList = {}
var MIN_DISTANCE_BETWEEN_RESOURCES = 0.1

@onready var _platform = $"ground"
@onready var _handleGoals = get_tree().root.get_child(0).get_node("HandleGoals")

func _ready():
	_handleGoals.connect("addNew", changePrecentage)

func detect_colliders(amountPlatforms, MAX_AMOUNT) -> int:
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
	return amountPlatforms + 1

# TODO: add other platforms to this
func generate_platforms():
	var rng = RandomNumberGenerator.new()
	var probability = rng.randf_range(1, 100)
	var type = ""

	print(probability)
	if in_between(0, probabilityDict["nothing"], probability):
		print("generate nothing")	
	elif in_between(probabilityDict["nothing"], probabilityDict["wood"], probability):
		print("generate wood")
		type = "wood"
	elif in_between(probabilityDict["wood"], probabilityDict["water"], probability):
		print("generate water")
		type = "water"
	elif in_between(probabilityDict["water"], probabilityDict["stone"], probability):
		print("generate stone")
		type = "stone"
	elif in_between(probabilityDict["stone"], probabilityDict["coal"], probability):
		print("generate coal")
		type = "coal"
	elif in_between(probabilityDict["coal"], probabilityDict["iron"], probability):
		print("generate iron")
		type = "iron"
	elif in_between(probabilityDict["iron"], probabilityDict["meat"], probability):
		print("generate meat")
		type = "meat"
	elif in_between(probabilityDict["meat"], probabilityDict["people"], probability):
		print("generate people")
		type = "people"
		
	if type != "":
		generate_resources(type)
	
func in_between(minVal, maxVal, number) -> bool:
	if number > minVal && number < maxVal:
		return true
	return false

func generate_resources(type):
	var rng = RandomNumberGenerator.new()
	var probability = rng.randf_range(1, 4)
	
	var cube_scale = self.get_node("ground").global_transform.basis.get_scale()
	var side_length = cube_scale.x / 2

	print(type)
	var path = str("res://scenes/", type, ".tscn")
	var resource = load(path)
	var i = 0
	while i < probability:
		var position_x = rng.randf_range(-0.3, side_length - 0.01)		
		var position_z = rng.randf_range(-0.3, side_length - 0.01)		
		
		var ground_position = _platform.global_transform.origin
		var resource_position = ground_position + Vector3(position_x, cube_scale.y, position_z)

		var too_close = false
		for generated_pos in resourcesList.values():
			if resource_position.distance_to(generated_pos) < MIN_DISTANCE_BETWEEN_RESOURCES:
				too_close = true
				break

		if not too_close:
			var _instance = resource.instantiate()
			get_tree().get_root().add_child(_instance)
			_instance.transform.origin = resource_position
			_instance.connect("destroyResource", destroyResource)
			resourcesList[_instance.global_position] = _instance.position
			i += 1
	
func destroyResource(resource):
	if resource.global_position in _platform.resourcesList.keys():
		_platform.resourceList.remove(resource.global_position)

func changePrecentage(type):
	if _handleGoals.goals.size() == 3:
		print(_handleGoals.goals.size())
		probabilityDict["nothing"] = 8
		probabilityDict["wood"] = 40
		probabilityDict["water"] = 80
		probabilityDict["stone"] = 100
	elif _handleGoals.goals.size() == 5:
		probabilityDict["nothing"] = 9
		probabilityDict["wood"] = 35
		probabilityDict["water"] = 60
		probabilityDict["stone"] = 80
		probabilityDict["coal"] = 100
	elif _handleGoals.goals.size() == 6:
		probabilityDict["nothing"] = 10
		probabilityDict["wood"] = 20
		probabilityDict["water"] = 40
		probabilityDict["stone"] = 60
		probabilityDict["coal"] = 80
		probabilityDict["iron"] = 100
	elif _handleGoals.goals.size() == 7:
		probabilityDict["nothing"] = 10
		probabilityDict["wood"] = 20
		probabilityDict["water"] = 40
		probabilityDict["stone"] = 60
		probabilityDict["coal"] = 73
		probabilityDict["iron"] = 85
		probabilityDict["meat"] = 100
	elif _handleGoals.goals.size() == 8:
		probabilityDict["nothing"] = 12
		probabilityDict["wood"] = 25
		probabilityDict["water"] = 37
		probabilityDict["stone"] = 48
		probabilityDict["coal"] = 62
		probabilityDict["iron"] = 74
		probabilityDict["meat"] = 86
		probabilityDict["people"] = 100
