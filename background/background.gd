class_name Background
extends Node2D

@export_category("Background")
@export var background_orig: Sprite2D
@export var background_textures: Array[CompressedTexture2D]
@export_range(10.0, 100.0, 2.0) var BG_SPEED: float = 20.0

@export_category("Foreground")
@export var foreground_orig: Sprite2D
@export var foreground_textures: Array[CompressedTexture2D]
@export_range(10.0, 100.0, 2.0) var FG_SPEED: float = 36.0

# assumed both textures have the same size, at least on x
@onready var size_x: float = background_textures[0].get_size().x
var backgrounds: Array[Sprite2D]
var foregrounds: Array[Sprite2D]
var init_x: float
# I want this to return 0 on int(bg_0_first),
#	this determines the position of the bg 0 in the scrolling
var bg_0_first: bool = !true
var fg_0_first: bool = !true


func _ready():
	set_process(false)
	Event.game_start.connect(set_process.bind(true))
	Event.game_over.connect(set_process.bind(false))
	Event.game_pause.connect(set_process)

	background_orig.texture = background_textures[0]
	foreground_orig.texture = foreground_textures[0]
	init_x = (size_x / 2.0) - (Global.INIT_WINDOW_SIZE.x / 2.0)

	backgrounds = _create_sprites(background_orig)
	foregrounds = _create_sprites(foreground_orig)


func _process(delta: float):
	_move_sprites(backgrounds, BG_SPEED)
	_move_sprites(foregrounds, FG_SPEED)
	bg_0_first = _reposition_sprites(backgrounds, bg_0_first)
	fg_0_first = _reposition_sprites(foregrounds, fg_0_first)


func _create_sprites(sprite: Sprite2D) -> Array[Sprite2D]:
	var sprites: Array[Sprite2D] = []
	sprite.position.x = init_x

	sprites.append(sprite.duplicate())
	sprites.append(sprite.duplicate())
	sprites[0].position.x += size_x

	add_child(sprites[0])
	add_child(sprites[1])
	sprite.visible = false
	return sprites


func _move_sprites(sprites: Array[Sprite2D], speed: float):
	for sprite in sprites:
		sprite.move_local_x(- speed * get_process_delta_time())


func _reposition_sprites(sprites: Array[Sprite2D], ifirst: bool) -> bool:
	if sprites[int(ifirst)].position.x <= init_x - size_x:
		print(ifirst)
		sprites[int(ifirst)].position.x = sprites[int(!ifirst)].position.x + size_x
		# update indexes
		return !ifirst
	return ifirst
