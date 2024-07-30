extends Node3D

#TODO: send signal to change this

signal changeText
signal destroyResource
signal goalAchieved
signal resourceSold

var type = ""

var rndMax = {
		"wood" : 4,
		"water" : 3,
	}

var total = {
	"wood" : 0,
	"water" : 0
}

var crntAmount:Dictionary = {
	"wood": 0,
	"water": 0,
}

func detect_object(collied_object, time, upgrade):
	if time >= 3 - upgrade:
		destroyResource.emit(collied_object)
		collied_object.queue_free()
		if collied_object.is_in_group("wood"):
			type = "wood"
		elif collied_object.is_in_group("water"):
			type = "water"
		total[type] += count_random(rndMax[type])
		crntAmount[type] += count_random(rndMax[type])
		if type != "":
			changeText.emit(type, crntAmount[type])
		goalAchieved.emit(type, total[type])

func count_random(maxInt) -> int:
	var rng = RandomNumberGenerator.new()
	return rng.randi_range(1, maxInt)

func changeResourceAmount(type):
	crntAmount[type] = 0
	changeText.emit(type, crntAmount[type])
