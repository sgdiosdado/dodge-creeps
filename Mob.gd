extends RigidBody2D

export var min_speed = 150
export var max_speed = 250

func _ready():
	var mob_types = $AnimatedSprite.frames.get_animation_names() # ["walk", "swim", "fly"]
	var random_index = randi() % mob_types.size()
	$AnimatedSprite.animation = mob_types[random_index]


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
