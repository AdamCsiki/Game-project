extends CharacterBody2D

@export var speed: int = 100
@export var health: int = 10
@export var Bullet: PackedScene = preload("res://Projectile/RedRocket.tscn")
@export var bulletDamage: int = 3
@export_range(1, 10, 1) var bulletCount: int = 1

@onready var healthbar = get_parent().get_node('HealthBar')
@onready var sfxAttack = get_node("AttackSFX")
@onready var currentHealth: int = health

var currTargets = []

# Called when the node enters the scene tree for the first time.
func _ready():
	healthbar.value = health
	healthbar.max_value = health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if len(currTargets):
		if is_instance_valid(currTargets[0]):
			look_at(currTargets[0].global_position)
			attack()
	
	get_parent().set_progress(get_parent().get_progress() + delta * speed)
		
	
	if get_parent().get_progress_ratio() == 1:
		get_parent().queue_free()

	if currentHealth <=0:
		get_parent().queue_free()
		
	if currentHealth < health:
		healthbar.visible = true 
		
	healthbar.value = currentHealth


func _on_area_2d_body_entered(body):
	if "Turret" in body.get_groups():
		currTargets.append(body)


func _on_area_2d_body_exited(body):
	if "Turret" in body.get_groups():
		currTargets.erase(body)
		
func attack():
	if len(currTargets) > 0 and get_parent().get_node("BulletContainer").get_child_count() < bulletCount:
		var target = currTargets[0].get_parent()
		var bullet = Bullet.instantiate()
		
		bullet.target_type = "Turret"
		bullet.target_location = target.global_position
		bullet.attackDamage = bulletDamage
		bullet.rotation = rotation
		get_parent().get_node("BulletContainer").add_child(bullet)
		bullet.global_position = get_node("Marker2D").global_position
		sfxAttack.play()
