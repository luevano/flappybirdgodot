class_name VolumeSlider
extends HSlider


func _ready() -> void:
	value_changed.connect(_on_value_changed)


func _on_value_changed(_value: float) -> void:
	Event.set_volume.emit(_value)
	release_focus()	
