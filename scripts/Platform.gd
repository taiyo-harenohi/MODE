extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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
			print(arrow_to_delete, " at position: ", arrow_to_delete.global_position)
	print("-----------------")
