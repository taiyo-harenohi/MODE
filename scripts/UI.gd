extends Control

@onready var _wood_label = $"wood_label"
@onready var _water_label = $"water_label"

@onready var _handle = $"../HandleResources"

# Called when the node enters the scene tree for the first time.
func _ready():
	_handle.connect("changeText", changeText)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func changeText(type, value):
	if type == "wood":
		_wood_label.text = str("Wood: ", value)
