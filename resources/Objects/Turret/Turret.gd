extends Node
class_name Turret


################################
# EXPORT PARAMS
################################
# parts
@export var body_path: NodePath
@export var head_path: NodePath
@export var target_path: NodePath
# movement
@export var elevation_speed_deg: float = 45
@export var rotation_speed_deg: float = 90
# bullets
@export var muzzle_velocity: float = 50
# constraints
@export var min_elevation: float = -10
@export var max_elevation: float = 60


@onready var body: Node = get_node(body_path)
@onready var head: Node = get_node(head_path)
@onready var target: Node = get_node(target_path)

@onready var elevation_speed: float = elevation_speed_deg * PI / 180.0
@onready var rotation_speed: float = rotation_speed_deg * PI / 180.0

var ttc: float
var current_target: Vector3
var current_aim: Vector3

var active: bool = true

func _ready() -> void:

	if head == null or body == null:
		active = false

	if target == null or not "linear_velocity" in target:
		active == false


func _process(delta: float) -> void:

	if not active:
		return

	_update_target_location()
	
	_rotate(delta)
	_elevate(delta)

func _update_target_location() -> void:
	current_target = target.global_transform.origin


func _rotate(delta: float) -> void:

	var y_target = _get_local_y()

	var final_y = sign(y_target) * min(rotation_speed * delta, abs(y_target))

	body.rotate_y(final_y)


func _elevate(delta: float) -> void:

	var x_target = _get_global_x()
	var x_diff = x_target - head.global_transform.basis.get_euler().x
	var final_x = sign(x_diff) * min(elevation_speed * delta, abs(x_diff))

	head.rotate_x(final_x)

	head.rotation_degrees.x = clamp(
		head.rotation_degrees.x,
		min_elevation, max_elevation
	)

func _get_ttc() -> float:

	var to_target = target.global_transform.origin - head.global_transform.origin
	var target_velocity = target.linear_velocity

	var a = target_velocity.dot(target_velocity) - muzzle_velocity * muzzle_velocity
	var b = 2 * target_velocity.dot(to_target)
	var c = to_target.dot(to_target)
	
	if a == 0:
		return 0.0
		
	var d = b * b - 4 * a * c
	if d < 0:
		return 0.0
	
	var p = -b / (2 * a)
	var q = sqrt(d) / (2 * a)

	var t1 = p - q
	var t2 = p + q

	var t = 0
	if t1 > t2 and t2 > 0:
		t = t1
	else:
		t = t2

	return max(0.0, t)


func _get_local_y() -> float:
	var local_target = head.to_local(current_target)
	var y_angle = Vector3.FORWARD.angle_to(local_target * Vector3(1, 0, 1))
	return y_angle * -sign(local_target.x)


func _get_global_x() -> float:
	var local_target = current_target - head.global_transform.origin
	return (local_target * Vector3(1, 0, 1)).angle_to(local_target) * sign(local_target.y)















