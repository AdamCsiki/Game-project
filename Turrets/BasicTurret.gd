extends StaticBody2D

@onready var defaultRotation = rotation
@onready var healthbar = get_parent().get_node("HealthBar")
@onready var currentHealth: int = health

@export var Bullet: PackedScene = preload("res://Projectile/RedRocket.tscn")
@export var bulletDamage: int = 5
@export var health: int = 50
@export_range(1, 10, 1) var bulletCount: int = 1

var pathName
var currTargets = []

# Called when the node enters the scene tree for the first time.
func _ready():
	healthbar.value = health
	healthbar.max_value = health

func _physics_process(delta):
	if len(currTargets) > 0:
		look_at(currTargets[0].global_position)
		attack()
	else:
		rotation = defaultRotation
		
		
	if currentHealth <=0:
		get_parent().queue_free()
	
	healthbar.value = currentHealth

func _on_area_2d_body_entered(body):
	if "Minion" in body.get_groups():
		currTargets.append(body)
#		print("New entry:", currTargets)
	

func _on_area_2d_body_exited(body):
	if "Minion" in body.get_groups():
		currTargets.erase(body)
#		print("Removed entry:", currTargets)

func attack():
	if len(currTargets) > 0 and get_parent().get_node("BulletContainer").get_child_count() < bulletCount:
		var target = currTargets[0].get_parent()
		var bullet = Bullet.instantiate()
		
		bullet.target_type = "Minion"
		bullet.target_location = target.global_position
		bullet.attackDamage = bulletDamage
		bullet.rotation = rotation
		get_parent().get_node("BulletContainer").add_child(bullet)
		bullet.global_position = get_node("Marker2D").global_position
