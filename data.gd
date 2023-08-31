extends Node

const DATA_PATH: String = "user://data.cfg"
const SCORE_SECTION: String = "score"
const CONFIG_SECTION: String = "config"

var _data: ConfigFile


func _ready() -> void:
	_load_data()


func save_data() -> void:
	var err: int = _data.save(DATA_PATH)
	if err != OK:
		print("[ERROR] Cannot save data.")


func set_new_high_score(high_score: int) -> void:
	_data.set_value(SCORE_SECTION, "high_score", high_score)


func get_high_score() -> int:
	return _data.get_value(SCORE_SECTION, "high_score")


func set_volume(volume: float) -> void:
	_data.set_value(CONFIG_SECTION, "volume", volume)


func get_volume() -> float:
	return _data.get_value(CONFIG_SECTION, "volume")


func set_mute(mute: bool) -> void:
	_data.set_value(CONFIG_SECTION, "mute", mute)


func get_mute() -> bool:
	return _data.get_value(CONFIG_SECTION, "mute")


func _load_data() -> void:
	_data = ConfigFile.new()
	var err: int = _data.load(DATA_PATH)
	if err == OK:
		return

	if err == ERR_FILE_NOT_FOUND:
		print("[WARN] Save data doesn't exist yet. Creating default.")
		set_new_high_score(0)
		set_volume(0.5)
		set_mute(false)
		save_data()
	else:
		print("[ERROR] Unexpected error while tryign to read file.")
