extends Control

@onready var _wood_label = $"wood_label"
@onready var _water_label = $"water_label"

@onready var _handle = $"../HandleResources"

func _ready():
	_handle.connect("changeText", changeText)

func _process(delta):
	pass

func changeText(type, value):
	if type == "wood":
		_wood_label.text = str("Wood: ", value)
	elif type == "water":
		_water_label.text = str("Water: ", value)
