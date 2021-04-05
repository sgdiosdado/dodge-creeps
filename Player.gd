extends Area2D

signal hit

export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.
var target = Vector2()

func _ready():
	hide()
	screen_size = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2()  # The player's movement vector.
	if position.distance_to(target) > 10:
		velocity = target - position
	velocity = _movement(velocity)
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	_choose_animation(velocity)

func _movement(velocity_vector):
	var velocity = velocity_vector
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	return velocity

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position

func _choose_animation(velocity):
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

func _on_Player_body_entered(_body):
	hide()  # Player disappears after being hit.
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	target = pos
	show()
	$CollisionShape2D.disabled = false
