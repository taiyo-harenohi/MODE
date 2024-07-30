extends Camera3D

var zoomSpeed: float = 2
var minZoom: float = 25.0
var maxZoom: float = 100.0
var dragSen: float = 2.0

var center: Vector3 = Vector3(0, 5, 2.5)
var zoom: float = 25

var mouse = Vector3()

var isHolding: bool = false
var time = 0

var platformInstance = load("res://scenes/platform.tscn")
var coins = 0

var MAX_AMOUNT = 10
var amountPlatforms = 0
var upgradeTime = 0

var prices:Dictionary = {
	"increase": 30, 
	"rooftop": 20,
	"platforms": 30,
}

# TODO: when hitting goal, adds to this the new resources types
# types to come -- stone, gemstones and coal, iron, deers and rabbits and chicken -> meat,
# energy from solar panels, people (their houses, so stone, wood etc. from it too
var amountSold:Dictionary = {
	"wood": 0, 
	"water": 0,
}

var resourcePrice:Dictionary = {
	"wood": 2,
	"water": 1.75,
}

@onready var _handlerResources = $"../HandleResources"
@onready var _handlerGoals = $"../HandleGoals"
@onready var _coins = $"../UI/coins"
@onready var _shop = $"../UI/shop"
@onready var _shopWindow = $"../UI/shop_window"
@onready var _sellWindow = $"../UI/sell_window"


var shopOpen: bool = false
var sellOpen: bool = false

func _ready():
	_handlerGoals.connect("increaseMaxAmount", increase_amount)

func _physics_process(delta):	
	if isHolding:
		time += delta
		get_selected()
	else: 
		time = 0
	if fov >= 80:
		dragSen = 4.0
	elif fov <= 45:
		dragSen = 0.5
	else: 
		dragSen = 1.5
	if coins > 0:
		_coins.show()
		_shop.show()
		
func _on_sell_pressed():
	sellOpen = !sellOpen
	if sellOpen:
		_sellWindow.show()
	else:
		_sellWindow.hide()
		
func _on_sell_wood_pressed():
	if _handlerResources.crntAmount["wood"] == 0:
		return
	coins += selling_price("wood")
	_coins.text = str("Coins: ", coins)

func _on_sell_water_pressed():
	if _handlerResources.crntAmount["water"] == 0:
		return
	coins += selling_price("water")
	_coins.text = str("Coins: ", coins)

func selling_price(type) -> float:
	amountSold[type] += _handlerResources.total[type]
	_handlerResources.changeResourceAmount(type)
	if resourcePrice[type] > 0.5:
		resourcePrice[type] -= amountSold[type] / 100.0
		print(amountSold[type]/100.0)
		print(resourcePrice)
	return amountSold[type] * resourcePrice[type]
	
func _on_shop_pressed():
	shopOpen = !shopOpen
	if shopOpen:
		_shopWindow.show()
	else: 
		_shopWindow.hide()

# make Simir´s rooftop bonita
func _on_roof_pressed():
	if coins >= prices["rooftop"]:
		print("better roof")		
		coins -= prices["rooftop"]
		_coins.text = str("Coins: ", coins)
		prices["rooftop"] *= 2	
		# TODO:
		# Simir´s new rooftop B-)
		# -> means changing the texture of the rooftop
		# + adding some new stuff
	else: 
		print("not enough money")

# make this gathering resources faster
func _on_boost_pressed():
	if coins >= prices["increase"] and upgradeTime < 2:
		print("increase amount of wood")
		coins -= prices["increase"]
		prices["increase"] *= 2
		upgradeTime += 0.5
	else: 
		print("not enough money")

# make the gathering place bigger 
func _on_more_platforms_pressed():
	if coins >= prices["platforms"]:
		increase_amount(2)
		coins -= prices["platforms"]
		prices["platforms"] *= 2
	else: 
		print("not enough money")
	
func _input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and shopOpen == false:
		position -= Vector3(event.relative.x, 0, event.relative.y) * dragSen / fov * 0.1

	if event is InputEventMouseButton and shopOpen == false:
		mouse = event.position
		if event.button_index == MOUSE_BUTTON_LEFT:
			isHolding = event.pressed
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			fov -= zoomSpeed
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			fov += zoomSpeed
		fov = clamp(fov, minZoom, maxZoom)
	
	# TODO: maybe smoother motion to go back to the center
	if Input.is_action_just_pressed("to_center"):
		position = center
	if Input.is_action_just_pressed("restart_zoom"):
		fov = zoom

# TODO: add count checking
func get_selected():
	var worldspace = get_world_3d().direct_space_state
	var start = project_ray_origin(mouse)
	var end = project_position(mouse, 1000)
	var result = worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(start, end))
	
	if result.has("collider"):
		if result["collider"].is_in_group("resources"):
			_handlerResources.detect_object(result["collider"], time, upgradeTime)
		elif result["collider"].is_in_group("arrow"):
			if amountPlatforms >= MAX_AMOUNT:
				print("exceeded limit")
			else: 
				var _instance = platformInstance.instantiate()
				get_tree().get_root().add_child(_instance)
				_instance.global_transform = result["collider"].global_transform	
				result["collider"].queue_free()
				amountPlatforms = _instance.detect_colliders(amountPlatforms, MAX_AMOUNT)	
				_instance.generate_platforms()

func increase_amount(progress):
	MAX_AMOUNT += 5 * progress
