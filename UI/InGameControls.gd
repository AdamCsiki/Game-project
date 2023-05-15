extends CanvasLayer

@onready var gameMap = null
@onready var minion =  preload("res://Minions/Soldier 1.tscn")
@onready var currencyDisplay = get_node('HBoxContainer/CurrencyAmount')
@onready var costMapping = {
	get_node('SpawnOne'): 10,
	get_node('SpawnTen'): 100
}

@export var currency: int = 1000

var spawnCount

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	currencyDisplay.text = str(currency)
	
	for button in costMapping:
		if costMapping[button] > currency:
			button.disabled = true
		else:
			button.disabled = false


func spawnMinion():
	var minionsPath = gameMap.get_node("MinionsPath")
	var minionInstance = minion.instantiate()
	var entityScale = gameMap.get_meta("entityScale") if gameMap.get_meta("entityScale") else 1
	
	if is_instance_valid(minionsPath):
		currency -= 10
		minionInstance.scale = Vector2(entityScale, entityScale)
		minionsPath.add_child(minionInstance)
		return true
	
	print("ERROR: Map does not have a path for minions!")
	return false


func _on_spawn_one_pressed():
	spawnMinion()


func _on_spawn_ten_pressed():
	if get_node("SpawnTimer").is_stopped():
		spawnCount = 10
		get_node("SpawnTimer").start()


func _on_spawn_timer_timeout():
	if spawnCount > 0:
		spawnMinion()
		spawnCount -= 1
	else:
		get_node("SpawnTimer").stop()
