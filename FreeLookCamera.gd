#Copyright © 2022 Marc Nahr: https://github.com/MarcPhi/godot-free-look-camera
extends Camera3D

var _velocity = 5.0

@onready var settingsPath = 'user://cameraSettings.json'
var settingsFile

var settings = {
	"sensitivity": 3.0,
	"max_speed": 1000.0,
	"min_speed": 0.2,
	"velocity": 5.0,
	"speed_scale": 1.17,
	"boost_speed_multiplier": 3.0
}

func writeDefaultSettingsToFile():
	settingsFile = FileAccess.open(settingsPath, FileAccess.WRITE)
	settingsFile.store_line(JSON.stringify(settings))
	settingsFile.close()

func loadSettings():
	if not FileAccess.open(settingsPath, FileAccess.READ):
		writeDefaultSettingsToFile()
	
	settingsFile = FileAccess.open(settingsPath, FileAccess.READ)
		
	var data = JSON.parse_string(settingsFile.get_as_text())
	
	settings = data

	settingsFile.close()

func mouseMovement(event):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotation.y -= event.relative.x / 1000 * settings.sensitivity
			rotation.x -= event.relative.y / 1000 * settings.sensitivity
			rotation.x = clamp(rotation.x, PI/-2, PI/2)

func mouseModes(event):
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_RIGHT:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if event.pressed else Input.MOUSE_MODE_VISIBLE)
			MOUSE_BUTTON_WHEEL_UP: # increase fly velocity
				_velocity = clamp(_velocity * settings.speed_scale, settings.min_speed, settings.max_speed)
			MOUSE_BUTTON_WHEEL_DOWN: # decrease fly velocity
				_velocity = clamp(_velocity / settings.speed_scale, settings.min_speed, settings.max_speed)

func _ready():
	loadSettings()
	
	if settings.velocity == null:
		writeDefaultSettingsToFile()
		
	_velocity = settings.velocity
	

func _input(event):
	if not current:
		return
	
	mouseMovement(event)
	mouseModes(event)

func _process(delta):
	if not current:
		return
		
	var direction = Vector3(
		float(Input.is_physical_key_pressed(KEY_D)) - float(Input.is_physical_key_pressed(KEY_A)),
		float(Input.is_physical_key_pressed(KEY_E)) - float(Input.is_physical_key_pressed(KEY_Q)), 
		float(Input.is_physical_key_pressed(KEY_S)) - float(Input.is_physical_key_pressed(KEY_W))
	).normalized()
	
	if Input.is_physical_key_pressed(KEY_SHIFT): # boost
		translate(direction * _velocity * delta * settings.boost_speed_multiplier)
	else:
		translate(direction * _velocity * delta)
