extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 15

# Get the gravity from the project settings to be synced with RigidBody nodes.
# var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = 50.0


@onready var camera = $CameraRotationAxis/Camera3D
@onready var mesh = $MeshInstance3D

var rayOrigin = Vector3()
var rayEnd = Vector3()

#func look_at_mouse_point():
#	var space_state = get_world_3d().direct_space_state
#	var mouse_position = get_viewport().get_mouse_position();
#
#	rayOrigin = camera.project_ray_origin(mouse_position)
#	rayEnd = rayOrigin + camera.project_ray_normal(mouse_position) * 2000 
#
#	var intersection = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd))
#
#	if not intersection.is_empty():
#		pos = intersection.position
#		camera.look_at(Vector3(pos.x, 0, pos.z), Vector3(0, 1, 0))
#		mesh.rotate_y(deg_to_rad(180))
		
		
func _input_event(curr_camera, event, curr_position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			camera.current = true


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and camera.current:
		velocity.y = JUMP_VELOCITY

	
	var direction = Vector3(
		float(Input.is_physical_key_pressed(KEY_D)) - float(Input.is_physical_key_pressed(KEY_A)),
		float(Input.is_physical_key_pressed(KEY_E)) - float(Input.is_physical_key_pressed(KEY_Q)), 
		float(Input.is_physical_key_pressed(KEY_S)) - float(Input.is_physical_key_pressed(KEY_W))
	).normalized() if camera.current else null
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
