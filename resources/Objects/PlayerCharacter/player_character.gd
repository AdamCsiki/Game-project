extends CharacterBody3D

const SPEED = 5.0
const CAMERA_ROTATION_SPEED = 0.5
const JUMP_VELOCITY = 15
var pos

# Get the gravity from the project settings to be synced with RigidBody nodes.
# var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = 50.0


@onready var camera = $SpringArm3D/Camera3D
@onready var mesh = $MeshInstance3D

var rayOrigin = Vector3()
var rayEnd = Vector3()

func look_at_mouse_point():
	var space_state = get_world_3d().direct_space_state
	var mouse_position = get_viewport().get_mouse_position();
	
	rayOrigin = camera.project_ray_origin(mouse_position)
	rayEnd = rayOrigin + camera.project_ray_normal(mouse_position) * 2000 
	
	var intersection = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd))
	
	if not intersection.is_empty():
		pos = intersection.position
		camera.look_at(Vector3(pos.x * CAMERA_ROTATION_SPEED, pos.y * CAMERA_ROTATION_SPEED, pos.z * CAMERA_ROTATION_SPEED), Vector3.UP)
		mesh.rotate_y(deg_to_rad(180))
		

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	
	var direction = Vector3(
		float(Input.is_physical_key_pressed(KEY_D)) - float(Input.is_physical_key_pressed(KEY_A)),
		float(Input.is_physical_key_pressed(KEY_E)) - float(Input.is_physical_key_pressed(KEY_Q)), 
		float(Input.is_physical_key_pressed(KEY_S)) - float(Input.is_physical_key_pressed(KEY_W))
	).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	look_at_mouse_point()
	
