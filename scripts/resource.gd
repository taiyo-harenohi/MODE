extends Node3D

#TODO: send signal to change this

signal changeText
signal destroyResource

var type = ""

var rndMax = {
		"wood" : 4,
		"water" : 3,
	}

var total = {
	"wood" : 0,
	"water" : 0
}

func detect_object(collied_object, time):
	if time >= 3:
		destroyResource.emit(collied_object)
		collied_object.queue_free()
		if collied_object.is_in_group("wood"):
			type = "wood"
			total[type] += int(count_random(rndMax[type]))
		elif collied_object.is_in_group("water"):
			type = "water"
			total[type] += int(count_random(rndMax[type]))
		
		if type != "":
			changeText.emit(type, total[type])

func count_random(maxInt) -> float:
	var rng = RandomNumberGenerator.new()
	return rng.randf_range(1, maxInt)
