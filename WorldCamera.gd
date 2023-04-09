extends Camera3D

@export_range(0, 10, 0.01) var sensitivity : float = 3
@export_range(0, 1000, 0.1) var default_velocity : float = 5
@export_range(0, 10, 0.01) var speed_scale : float = 1.17
@export_range(1, 100, 0.1) var boost_speed_multiplier : float = 3.0
@export var max_speed : float = 1000
@export var min_speed : float = 0.2

@onready var _velocity = default_velocity

var direction = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not current:
		return
	if not direction.is_zero_approx():
		if Input.is_physical_key_pressed(KEY_SHIFT): # boost
		#	translate(direction * _velocity * delta * boost_speed_multiplier)
			self.set_position(direction * _velocity * delta * boost_speed_multiplier + self.get_position())
		else:
		#	translate(direction * _velocity * delta)
			self.set_position(direction * _velocity * delta + self.get_position())
		
	direction = Vector3(
		float(Input.is_physical_key_pressed(KEY_D)) - float(Input.is_physical_key_pressed(KEY_A)),
		float(Input.is_physical_key_pressed(KEY_SPACE)) - float(Input.is_physical_key_pressed(KEY_CTRL)), 
		float(Input.is_physical_key_pressed(KEY_S)) - float(Input.is_physical_key_pressed(KEY_W))
	).normalized()
