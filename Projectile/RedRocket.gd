extends CharacterBody2D

var target_location
var speed = 1000
var attackDamage

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
	if "Minion" in body.get_groups():
		body.health -= attackDamage
		queue_free()



func _on_timer_timeout():
	queue_free()
