extends Node

const SAVE_DIR = "user://saves/"
const SAVE_FILE = SAVE_DIR + "save_%d.dat"

## При успешном сохранении испускает сигнал.
signal save_created()
## При успешной загрузке испускает сигнал.
signal save_loaded()

## Ссздает файл сохранения на основании SaveData.
func _ready():
	##  Создаем директорию для сохранений если не существует
	DirAccess.make_dir_absolute(SAVE_DIR)

func save_game(save_data: SaveData) -> bool:
	var file_path = SAVE_FILE
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file == null: ## Если нет файла сохранения
		push_error("Ошибка сохранения: %s" % FileAccess.get_open_error())
		return false
	## Преобразуем данные сохранения и записываем в файл
	var json_string = JSON.stringify(save_data.to_dict())
	file.store_string(json_string)
	file.close()
	
	emit_signal("save_created")
	return true

## Возвращает SaveData из файла сохранения.
func load_game() -> SaveData:
	var file_path = SAVE_FILE
	if not FileAccess.file_exists(file_path): ## Если нет файла сохранения
		push_error("Файл сохранения не существует: %s" % file_path)
		return null
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null: ## Если не получилось прочитать файл 
		push_error("Ошибка загрузки: %s" % FileAccess.get_open_error())
		return null
	## Читаем файл
	var json_string = file.get_as_text()
	file.close()
	## Расшифровываем файл
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result != OK:
		push_error("Ошибка парсинга JSON")
		return null
	## Переписываем данные в save_data
	var data = json.data
	var save_data = SaveData.new()
	save_data.from_dict(data)
	emit_signal("save_loaded")
	return save_data

## Возвращает существует ли файл сохранения.
func save_exists() -> bool:
	return FileAccess.file_exists(SAVE_FILE)
