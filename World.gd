extends WorldEnvironment

@onready var the_cube = $TheCube

func _physics_process(delta):
	get_tree().call_group("units", "update_target_location", the_cube.global_transform.origin)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
