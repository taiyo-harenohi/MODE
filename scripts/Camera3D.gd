extends Camera3D

var zoomSpeed: float = 0.05
var minZoom: float = 0.1
var maxZoom: float = 2.0

func _input(event):
	if event is InputEventMouse:
		position -= event.relative 
