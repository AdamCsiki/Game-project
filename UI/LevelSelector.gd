extends CanvasLayer

@onready var loadingLabel = get_node("PanelContainer/VBoxContainer/LoadingLabel")
@onready var levelButtons = get_node("PanelContainer/VBoxContainer/LevelButtons")

@onready var root = get_parent()
@onready var camera = get_parent().get_node("WorldCamera")
@onready var controls = get_parent().get_node("InGameControls")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_tutorial_button_pressed():
	startLevel("res://Maps/StarterMap.tscn")


func _on_dungeon_button_pressed():
	startLevel("res://Maps/SnakeyMap.tscn")


func _on_beach_button_pressed():
	startLevel("res://Maps/Beach.tscn")


func startLevel(levelPath: String):
	levelButtons.hide()
	loadingLabel.show()
	
	var level = load(levelPath).instantiate()
	level.set_name("GameMap")
	root.add_child(level)
	controls.gameMap = level
	
	controls.show()
	camera.lock = false
	
	queue_free()

