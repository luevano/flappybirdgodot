extends HSlider


func _ready() -> void:
	value_changed.connect(_on_value_changed)
	mouse_exited.connect(_on_mouse_exited)


func _on_value_changed(_value: float) -> void:
	Event.set_volume.emit(_value)


func _on_mouse_exited() -> void:
	release_focus()	