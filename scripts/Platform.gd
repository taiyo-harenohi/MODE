extends Node3D

var probabilityDict = {
	"nothing": 6,
	"wood": 53,
	"water": 100,
}

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

func generate_resources():
	var rng = RandomNumberGenerator.new()
	var probability = rng.randf_range(1, 100)

	if in_between(0, probabilityDict["nothing"], probability):
		print("generate nothing")	
	elif in_between(probabilityDict["nothing"], probabilityDict["wood"], probability):
		print("generate wood")
	elif in_between(probabilityDict["wood"], probabilityDict["water"], probability):
		print("generate water")
	
func in_between(minVal, maxVal, number) -> bool:
	if number > minVal && number < maxVal:
		return true
	return false
