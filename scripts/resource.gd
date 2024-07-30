extends Node3D

signal changeText
signal destroyResource
signal goalAchieved
signal resourceSold

var type = ""

var rndMax:Dictionary = {
		"wood" : 4,
		"water" : 3,
	}

var total:Dictionary = {
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
		elif collied_object.is_in_group("stone"):
			type = "stone"
		elif collied_object.is_in_group("coal"):
			type = "coal"
		elif collied_object.is_in_group("iron"):
			type = "iron"
		elif collied_object.is_in_group("meat"):
			type = "meat"
		elif collied_object.is_in_group("people"):
			type = "people"
		var addValue = count_random(rndMax[type])
		total[type] += addValue
		crntAmount[type] += addValue
		if type != "":
			changeText.emit(type, crntAmount[type])
		goalAchieved.emit(type, total[type])

func count_random(maxInt) -> int:
	var rng = RandomNumberGenerator.new()
	return rng.randi_range(1, maxInt)

func changeResourceAmount(type):
	crntAmount[type] = 0
	changeText.emit(type, crntAmount[type])

func create_new_resource(type, max):
	var rng = RandomNumberGenerator.new()
	rndMax[type] = max
	total[type] = 0
	crntAmount[type] = 0
	changeText.emit(type, crntAmount[type])
