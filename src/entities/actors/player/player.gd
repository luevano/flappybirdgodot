class_name Player
extends KinematicBody2D

signal died
var dead: bool = false

export(float, 1.0, 1000.0, 1.0) var SPEED: float = 100.0
export(float, 0.01, 100.0, 0.01) var ROT_SPEED: float = 10.0
export(float, 1.0, 1000.0, 1.0) var JUMP_VELOCITY: float = 350.0

onready var sprite: AnimatedSprite = $Sprite

var gravity: float = 10 * ProjectSettings.get_setting("physics/2d/default_gravity")
var velocity: Vector2 = Vector2.ZERO
var last_collision: KinematicCollision2D


func _physics_process(delta: float) -> void:
	velocity.x = SPEED
	velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and not dead:
		velocity.y = -JUMP_VELOCITY

	if velocity.y < 0.0:
		sprite.play()
		if rotation > -PI/8:
			rotate(-0.05 * ROT_SPEED)
	else:
		_stop_sprite()
		if rotation < PI/2:
			rotate(0.01 * ROT_SPEED)

	# maybe can be done with move_and_collide, but this works
	velocity = move_and_slide(velocity)
	last_collision = get_last_slide_collision()

	if not dead and last_collision:
		_emit_player_died()


func _stop_sprite() -> void:
	if sprite.playing:
		sprite.stop()
	if sprite.frame != 0:
		sprite.frame = 0


# when dying because of boundary
func _on_CeilingDetector_body_entered(body: Node2D) -> void:
	_emit_player_died()


func _emit_player_died() -> void:
	# bit 2 corresponds to pipe (starts from 0)
	set_collision_mask_bit(2, false)
	dead = true
	SPEED = 0.0
	emit_signal("died")
