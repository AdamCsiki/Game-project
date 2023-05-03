extends CharacterBody2D

@export var speed = 1000

func _ready():
    pass

func _process(delta):
    get_parent().set_progress(get_parent().get_progress() + delta * speed)
    if get_parent().get_progress_ratio() == 1:
        queue_free()