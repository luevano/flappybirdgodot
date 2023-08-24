class_name VolumeButton
extends TextureButton

@export var icon_volume: CompressedTexture2D
@export var icon_volume_mute: CompressedTexture2D

var _opaque: Color = Color(1, 1, 1, 1)
var _translucent: Color = Color(1, 1, 1, 0.5)


func _ready():
	modulate = _translucent
	_set_icon(button_pressed)

	toggled.connect(_on_toggled)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _set_icon(mute: bool) -> void:
	if mute:
		texture_normal = icon_volume_mute
	else:
		texture_normal = icon_volume


func _on_toggled(_button_pressed: bool) -> void:
	Event.set_mute.emit(_button_pressed)
	_set_icon(_button_pressed)
	release_focus()


func _on_mouse_entered() -> void:
	modulate = _opaque


func _on_mouse_exited() -> void:
	modulate = _translucent
