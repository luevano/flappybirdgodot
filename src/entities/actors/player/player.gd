class_name Player
extends KinematicBody2D

signal died
var input_disabled: bool = false

export(float, 1.0, 1000.0, 1.0) var SPEED: float = 100.0
export(float, 0.01, 100.0, 0.01) var ROT_SPEED: float = 10.0
export(float, 1.0, 1000.0, 1.0) var JUMP_VELOCITY: float = 350.0

onready var sprite: AnimatedSprite = $Sprite

var gravity: float = 10 * ProjectSettings.get_setting("physics/2d/default_gravity")
var velocity: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	velocity.x = SPEED
	velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and not input_disabled:
		velocity.y = -JUMP_VELOCITY

	if velocity.y < 0.0:
		sprite.play()
		if rotation > -PI/8:
			rotate(-0.05 * ROT_SPEED)
	else:
		_stop_sprite()
		if rotation < PI/2:
			rotate(0.01 * ROT_SPEED)

	# when dying because of ground or pipe
	# if not input_disabled:
	# 	pass
	# else:
	# 	input_disabled = true
	# 	SPEED = 0.0
	# 	emit_signal("died")

	velocity = move_and_slide(velocity)


func _stop_sprite() -> void:
	if sprite.playing:
		sprite.stop()
	if sprite.frame != 0:
		sprite.frame = 0


# when dying because of boundary
func _on_ceiling_detector_body_entered(body: Node2D) -> void:
	input_disabled = true
	SPEED = 0.0
	emit_signal("died")
