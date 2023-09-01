class_name Background
extends CanvasLayer

@export var background_texture: CompressedTexture2D
@export var background_orig: Sprite2D
@export_range(10.0, 100.0, 2.0) var SPEED: float = 20.0

var texture_size: Vector2
var backgrounds: Array[Sprite2D]
# I want this to return 0 on int(bg_0_first),
#	this determines the position of the bg 0 in the scrolling
var bg_0_first: bool = !true
var i0: int = int(bg_0_first)
var i1: int = int(!bg_0_first)


func _ready():
	set_process(false)
	Event.game_start.connect(set_process.bind(true))
	Event.game_over.connect(set_process.bind(false))
	Event.game_pause.connect(set_process)

	background_orig.texture = background_texture
	texture_size = background_orig.texture.get_size()

	backgrounds.append(background_orig.duplicate())
	backgrounds.append(background_orig.duplicate())
	backgrounds[1].position = background_orig.position + Vector2(texture_size.x, 0.0)

	add_child(backgrounds[0])
	add_child(backgrounds[1])
	background_orig.visible = false


func _process(delta: float):
	for background in backgrounds:
		background.move_local_x(- SPEED * delta)

	# moves the sprite that just exited the screen next to the upcoming sprite
	if backgrounds[i0].position.x <= - background_orig.position.x:
		backgrounds[i0].position.x = backgrounds[i1].position.x + texture_size.x
		# update indexes
		bg_0_first = !bg_0_first
		i0 = int(bg_0_first)
		i1 = int(!bg_0_first)
