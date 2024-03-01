class_name GameOverPanel
extends PanelContainer

@export var high_score_label: Label
@export var bird_selection: PanelItem
@export var bg_selection: PanelItem

@onready var _initial_high_score: int = Data.get_high_score()
@onready var _bird: int = Data.get_bird()
@onready var _bg: int = Data.get_background()


func _ready():
	Event.new_score.connect(_on_new_score)
	Event.bird_new_sprite.connect(_on_bird_new_sprite)
	Event.bg_new_sprite.connect(_on_bg_new_sprite)
	bird_selection.prev_pressed.connect(_on_bird_prev_pressed)
	bird_selection.next_pressed.connect(_on_bird_next_pressed)
	bg_selection.prev_pressed.connect(_on_bg_prev_pressed)
	bg_selection.next_pressed.connect(_on_bg_next_pressed)

	_on_new_score(-1, _initial_high_score)
	_on_bird_new_sprite(_bird)
	_on_bg_new_sprite(_bg)


func _on_new_score(_score: int, high_score: int):
	high_score_label.set_text(Global.HS_TEXT % high_score)


func _on_bird_new_sprite(index: int):
	bird_selection.set_selection_text(str(index + 1))


func _on_bg_new_sprite(index: int):
	bg_selection.set_selection_text(str(index + 1))


func _on_bird_prev_pressed():
	Event.bird_prev_sprite.emit()


func _on_bird_next_pressed():
	Event.bird_next_sprite.emit()


func _on_bg_prev_pressed():
	Event.bg_prev_sprite.emit()


func _on_bg_next_pressed():
	Event.bg_next_sprite.emit()
