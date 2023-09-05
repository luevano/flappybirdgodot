class_name PanelItem
extends HBoxContainer

signal prev_pressed
signal next_pressed

@export var label: Label
@export var selection_label: Label
@export var prev: TextureButton
@export var next: TextureButton
@export var text: String = "Test"
@export var selection_text: String = "1"

var _opaque: Color = Color(1, 1, 1, 1)
var _translucent: Color = Color(1, 1, 1, 0.75)


func _ready():
	prev.pressed.connect(_on_prev_pressed)
	prev.mouse_entered.connect(_on_mouse_entered.bind(prev))
	prev.mouse_exited.connect(_on_mouse_exited.bind(prev))

	next.pressed.connect(_on_next_pressed)
	next.mouse_entered.connect(_on_mouse_entered.bind(next))
	next.mouse_exited.connect(_on_mouse_exited.bind(next))

	prev.modulate = _translucent
	next.modulate = _translucent
	set_text(text)
	set_selection_text(selection_text)


func set_text(_text: String):
	label.set_text(_text)


func set_selection_text(_text: String):
	selection_label.set_text(_text)


func _on_prev_pressed():
	prev_pressed.emit()
	prev.release_focus()


func _on_next_pressed():
	next_pressed.emit()
	next.release_focus()


func _on_mouse_entered(button: TextureButton):
	button.modulate = _opaque


func _on_mouse_exited(button: TextureButton):
	button.modulate = _translucent
