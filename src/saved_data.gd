extends Node

const DATA_PATH: String = "user://data.cfg"
const SCORE_SECTION: String = "score"

var _data: ConfigFile


func _ready() -> void:
	print("[DEBUG] Save data autoload _ready() start.")
	_load_data()
	print("[DEBUG] Saved data autoload _ready() finish.")


func save_data() -> void:
	var err: int = _data.save(DATA_PATH)
	if err != OK:
		print("[ERROR #%d] Cannot save data." % err)


func set_new_high_score(high_score: int) -> void:
	_data.set_value(SCORE_SECTION, "high_score", high_score)


func get_high_score() -> int:
	return _data.get_value(SCORE_SECTION, "high_score")


func _load_data() -> void:
	_data = ConfigFile.new()
	var err: int = _data.load(DATA_PATH)
	if err == OK:
		return

	if err == ERR_FILE_NOT_FOUND:
		print("[WARN] Save data doesn't exist yet. Creating default.")
		set_new_high_score(0)
		save_data()
	else:
		print("[ERROR #%d] Unexpected error while tryign to read file." % err)
