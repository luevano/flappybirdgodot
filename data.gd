extends Node

const DATA_PATH: String = "user://data.tres"

var _data: DataResource


func _ready():
	_load_data()


func save():
	var err: int = ResourceSaver.save(_data, DATA_PATH)
	if err != OK:
		print("[ERROR] Couldn't save data.")


func _load_data():
	if ResourceLoader.exists(DATA_PATH):
		_data = load(DATA_PATH)
	else:
		_data = DataResource.new()
		print(_data)
		save()


func set_high_score(high_score: int):
	_data.high_score = high_score


func get_high_score() -> int:
	return _data.high_score


func set_volume(volume: float):
	_data.volume = volume


func get_volume() -> float:
	return _data.volume


func set_mute(mute: bool):
	_data.mute = mute


func get_mute() -> bool:
	return _data.mute


func set_bird(bird: int):
	_data.bird = bird


func get_bird() -> int:
	return _data.bird


func set_background(bg: int):
	_data.background = bg


func get_background() -> int:
	return _data.background
