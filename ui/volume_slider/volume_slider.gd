class_name VolumeSlider
extends HSlider

@onready var _volume: float = Data.get_volume()


func _ready():
	value = _volume
	value_changed.connect(_on_value_changed)


func _on_value_changed(_value: float):
	Event.set_volume.emit(_value)
	release_focus()
