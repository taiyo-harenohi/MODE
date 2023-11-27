extends Node3D

@onready var _wood_label = $"../UI/wood_label"
@onready var _water_label = $"../UI/water_label"

var rndMax = {
		"wood" : 4,
		"water" : 3,
	}

var total = {
	"wood" : 0,
	"water" : 0
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func detect_object(collied_object, time):
	if time >= 3:
		collied_object.queue_free()
		if collied_object.is_in_group("wood"):
			total["wood"] += int(count_random(rndMax["wood"]))
			_wood_label.text = str("Wood: ", total["wood"])
		elif collied_object.is_in_group("water"):
			total["water"] += int(count_random(rndMax["water"]))
			_water_label.text = str("Water: ", total["water"])

func count_random(max) -> float:
	var rng = RandomNumberGenerator.new()
	return rng.randf_range(1, max)
