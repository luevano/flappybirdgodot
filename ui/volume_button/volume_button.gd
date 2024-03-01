class_name VolumeButton
extends TextureButton

var _opaque: Color = Color(1, 1, 1, 1)
var _translucent: Color = Color(1, 1, 1, 0.5)

@onready var _mute: bool = Data.get_mute()


func _ready():
	toggled.connect(_on_toggled)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	modulate = _translucent
	button_pressed = _mute


func _on_toggled(_button_pressed: bool):
	Event.set_mute.emit(_button_pressed)
	release_focus()


func _on_mouse_entered():
	modulate = _opaque


func _on_mouse_exited():
	modulate = _translucent
