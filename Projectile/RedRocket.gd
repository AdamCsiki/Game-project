extends CharacterBody2D

var target_type: String
var target_location
var speed: int = 1000
var attackDamage: int = 1

#@onready var destination = (target_location - position) * 0.5 + position

func _physics_process(delta):
	position += transform.x * speed * delta
#	if is_instance_valid(target):
#	velocity = global_position.direction_to(destination) * Speed
#	print(destination)
#	look_at(destination)
#
#	move_and_slide()


func _on_area_2d_body_entered(body):
	if target_type in body.get_groups():
		body.currentHealth -= attackDamage
		queue_free()



func _on_timer_timeout():
	queue_free()
