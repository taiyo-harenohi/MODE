extends Node3D

@onready var _handlerResources = $"../HandleResources"

var goals = {
	"wood": 20,
	"water": 10
}

var valueAll = {
	"wood": 0,
	"water": 0
}

var achieved = {}

var isAchieved: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	_handlerResources.connect("goalAchieved", goalAchieved)
	
func goalAchieved(type, value):
	var numberGoals = goals.size() - 1
	var goal_value = goals[type]
	valueAll[type] = value
	print(goal_value)
	print(valueAll[type])
	if goal_value <= valueAll[type]:
		print("sub-goal achieved")
		achieved[type] = 0
	if achieved.size() == goals.size():
		print("goal achieved")
		for key in achieved:
			achieved.erase(key)
		for key in goals: 
			goals[key] += 10
		isAchieved = false
