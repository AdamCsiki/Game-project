extends Node2D

@onready var soldierPath = preload("res://Mobs/Soldier 1.tscn")
@onready var mapPath = get_parent().get_node("Path2D")

func _on_timer_timeout():
	var soldier = soldierPath.instantiate()
	mapPath.add_child(soldier)
