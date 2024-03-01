class_name Player
extends CharacterBody2D

@export_range(0.01, 100.0, 0.01) var rot_speed: float = 10.0
@export_range(1.0, 300.0, 1.0) var jump_velocity: float = 160.0
@export_range(1.0, 100.0, 1.0) var death_jump_velocity: float = 150.0
@export_range(10.0, 1000.0, 1.0) var gravity: float = 500.0

# needs to match the animation sprite names
var animations: Array[String] = ["bird_1", "bird_2", "bird_3"]
var last_collision: KinematicCollision2D
var dead: bool = false

@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var _bird: int = Data.get_bird()


func _ready():
	set_physics_process(false)
	Event.game_start.connect(set_physics_process.bind(true))
	Event.game_pause.connect(set_physics_process)
	Event.game_pause.connect(_stop_sprite)
	Event.player_collide.connect(_on_player_collide)
	Event.bird_prev_sprite.connect(_on_bird_prev_sprite)
	Event.bird_next_sprite.connect(_on_bird_next_sprite)

	sprite.set_animation(animations[_bird])


func _physics_process(delta: float):
	velocity.y += gravity * delta

	if (Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("touch")) and not dead:
		velocity.y = -jump_velocity
		Event.player_jump.emit()

	if velocity.y < 0.0:
		sprite.play()
		if rotation > -PI / 8:
			rotate(-0.05 * rot_speed)
	else:
		_stop_sprite()
		if rotation < PI / 2:
			rotate(0.01 * rot_speed)

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
	velocity.y = -death_jump_velocity
	set_velocity(velocity)
	move_and_slide()


func _get_new_anim_index(index: int) -> int:
	return clampi(index, 0, animations.size() - 1)


func _set_sprites_index(index: int) -> int:
	var new_index: int = _get_new_anim_index(index)
	if new_index == _bird:
		return new_index

	sprite.set_animation(animations[new_index])

	_bird = new_index
	Data.set_bird(_bird)
	Data.save()
	return new_index


func _on_bird_prev_sprite():
	Event.bird_new_sprite.emit(_set_sprites_index(_bird - 1))


func _on_bird_next_sprite():
	Event.bird_new_sprite.emit(_set_sprites_index(_bird + 1))
