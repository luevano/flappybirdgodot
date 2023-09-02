class_name Player
extends CharacterBody2D

@export_range(0.01, 100.0, 0.01) var ROT_SPEED: float = 10.0
@export_range(1.0, 300.0, 1.0) var JUMP_VELOCITY: float = 160.0
@export_range(1.0, 100.0, 1.0) var DEATH_JUMP_VELOCITY: float = 150.0
@export_range(10.0, 1000.0, 1.0) var GRAVITY: float = 500.0

@onready var sprite: AnimatedSprite2D = $Sprite2D

var last_collision: KinematicCollision2D
var dead: bool = false


func _ready():
	set_physics_process(false)
	Event.game_start.connect(set_physics_process.bind(true))
	Event.game_pause.connect(set_physics_process)
	Event.game_pause.connect(_stop_sprite)
	Event.player_collide.connect(_on_player_collide)


func _physics_process(delta: float):
	velocity.y += GRAVITY * delta

	if (Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("touch")) and not dead:
		velocity.y = -JUMP_VELOCITY
		Event.player_jump.emit()

	if velocity.y < 0.0:
		sprite.play()
		if rotation > -PI/8:
			rotate(-0.05 * ROT_SPEED)
	else:
		_stop_sprite()
		if rotation < PI/2:
			rotate(0.01 * ROT_SPEED)

	# maybe can be done with move_and_collide, but this works
	set_velocity(velocity)
	move_and_slide()
	velocity = velocity
	last_collision = get_last_slide_collision()

	if not dead and last_collision:
		Event.player_collide.emit()


func _stop_sprite(stop: bool = true):
	if sprite.is_playing():
		sprite.stop()
	if sprite.frame != 0:
		sprite.frame = 0


func _on_player_collide():
	set_collision_mask_value(3, false)
	dead = true
	Event.player_death.emit()
	velocity.y = -DEATH_JUMP_VELOCITY
	set_velocity(velocity)
	move_and_slide()
