extends Node3D

@onready var _handlerResources = $"../HandleResources"
@onready var _goalWindow = $"../UI/goal achieved"

var goals = {
	"wood": 20,
	"water": 10
}

var achieved = {}
var isAchieved: bool = false
var progressTracker = 1

var newResource:Array = [
	"stone",
	"coal", 
	"gem",
	"iron",
	"meat",
	"people"
]

var newResourceValue:Array = [12, 5, 3, 5, 10, 20]

signal increaseMaxAmount

func _ready():
	_handlerResources.connect("goalAchieved", goalAchieved)
	
func goalAchieved(type, value):
	var numberGoals = goals.size() - 1
	if goals[type] <= value:
		achieved[type] = value
		print(type)
	if achieved.size() == goals.size():
		for key in achieved:
			achieved.erase(key)
		for key in goals: 
			goals[key] += 10
		# TODO: make the window disappear after animation is done
		# TODO: show cutscene, show new text label, show animation "goal achieved"
		# _goalWindow.show()
		isAchieved = false
		progressTracker += 1.5
		for goal in goals.values():
			var rng = RandomNumberGenerator.new()
			goal *= rng.randf_range(1.1, 2)
		goals[newResource[0]] = newResourceValue[0]
		newResource.erase(newResource[0])
		newResourceValue.erase(newResourceValue[0])
		increaseMaxAmount.emit(progressTracker)
