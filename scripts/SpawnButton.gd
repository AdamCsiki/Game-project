extends Button

@export var EntityToSpawn: PackedScene = preload("res://Minions/Soldier 1.tscn")

@onready var mapPath = get_parent().get_node("MinionsPath")
@onready var timer = get_node("Timer")

var count = 0

func _on_pressed():
	if Input.is_physical_key_pressed(KEY_SHIFT):
		self.disabled = true
		timer.start()
	else:
		mapPath.add_child(EntityToSpawn.instantiate())
	


func _on_timer_timeout():
	if count < 10:
		mapPath.add_child(EntityToSpawn.instantiate())
		count += 1
	else:
		timer.stop()
		count = 0
		self.disabled = false
