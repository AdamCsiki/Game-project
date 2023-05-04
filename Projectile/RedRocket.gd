extends CharacterBody2D

var target
var Speed = 1000
var attackDamage

func _physics_process(delta):
	if is_instance_valid(target):
		velocity = global_position.direction_to(target.global_position) * Speed
		
		look_at(target.global_position)
	
	move_and_slide()


func _on_area_2d_body_entered(body):
	if "Minion" in body.get_groups():
		body.health -= attackDamage
		queue_free()



func _on_timer_timeout():
	queue_free()
