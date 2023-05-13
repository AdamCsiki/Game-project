extends CharacterBody2D

@export var speed: int = 100
@export var health: int = 10

@onready var healthbar = get_parent().get_node('HealthBar')

# Called when the node enters the scene tree for the first time.
func _ready():
	healthbar.value = health
	healthbar.max_value = health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_parent().set_progress(get_parent().get_progress() + delta * speed)
	if get_parent().get_progress_ratio() == 1:
		queue_free()

	if health <=0:
		get_parent().queue_free()
		
	healthbar.value = health
		

func _on_mouse_entered():
	healthbar.visible = true


func _on_mouse_exited():
	healthbar.visible = false
