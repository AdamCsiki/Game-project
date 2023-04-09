extends Node3D

@export_range(0, 10, 0.01) var sensitivity : float = 3

@onready var camera = $Camera3D


func _input(event):
	if not camera.current:
		return
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotation.y = fmod((rotation.y + event.relative.x / 1000 * sensitivity) , 360)
			
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_RIGHT:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if event.pressed else Input.MOUSE_MODE_VISIBLE)

