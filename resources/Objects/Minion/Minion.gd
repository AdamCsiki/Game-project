extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var animation = $spider_model/AnimationPlayer

var SPEED = 3.0

func _physics_process(delta):
	var current_position = global_transform.origin
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - current_position).normalized() * SPEED
	
	animation.play("Armature|large walk", -1, 2)
	
	velocity = velocity.move_toward(new_velocity, delta)
	
	move_and_slide()

func update_target_location(target_location):
	nav_agent.set_target_position(target_location)
