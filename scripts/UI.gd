extends Control

@onready var _labels = $resources_labels
@onready var _handle = $"../HandleResources"

func _ready():
	_handle.connect("changeText", changeText)

func _process(delta):
	pass

func changeText(type, value):
	for label in _labels.get_children():
		if label.to_string().contains(type):
			if !label.visible:
				label.visible = true
			label.text = str(type, ": ", value)
