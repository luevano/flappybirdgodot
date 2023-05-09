extends Node

const DATA_PATH: String = "user://data.cfg"
const SCORE_SECTION: String = "score"

var _data: ConfigFile


func _ready() -> void:
	_load_data()

	if not _data.has_section(SCORE_SECTION):
		set_new_high_score(0)
		save_data()


func save_data() -> void:
	var err: int = _data.save(DATA_PATH)
	if err != OK:
		print("[ERROR] Cannot save data.")


func set_new_high_score(high_score: int) -> void:
	_data.set_value(SCORE_SECTION, "high_score", high_score)


func get_high_score() -> int:
	return _data.get_value(SCORE_SECTION, "high_score")


func _load_data() -> void:
	# create an empty file if not present to avoid error while loading settings
	var file: File = File.new()
	if not file.file_exists(DATA_PATH):
		file.open(DATA_PATH, file.WRITE)
		file.close()

	_data = ConfigFile.new()
	var err: int = _data.load(DATA_PATH)
	if err != OK:
		print("[ERROR] Cannot load data.")
