class_name SaveData
var version: String = "1.0"
var timestamp: String

var score: int
var player_lives: int

var player_position: Vector2 ## Положение игрока.
var ghosts_positions: Dictionary = {}  ## Все призраки и их позиции.
var coins_positions: Dictionary = {}   ## Все монеты и их позиции.
var tilemap_data: Dictionary = {} ## Данные tileMаp: слои, позиции тайлов и их координаты в атласе.

func _init():
	timestamp = Time.get_datetime_string_from_system()

## Формируем SaveData.
func to_dict() -> Dictionary:
	return {
		"timestamp": timestamp,
		"score": score,
		"player_lives": player_lives,
		"tilemap_data": tilemap_data,
		"player_position": { "x": player_position.x, "y": player_position.y },
		"ghosts_positions": _vector2_dict_to_dict(ghosts_positions),
		"coins_positions": _vector2_dict_to_dict(coins_positions)
	}

## Загружаем SaveData.
func from_dict(data: Dictionary) -> void:
	timestamp = data.get("timestamp", "")
	score = data.get("score", 0)
	player_lives = data.get("player_lives", 1)
	tilemap_data = data.get("tilemap_data", {})
	player_position = _dict_to_vector2(data.get("player_position", {}))
	ghosts_positions = _dict_to_vector2_dict(data.get("ghosts_positions", {}))
	coins_positions = _dict_to_vector2_dict(data.get("coins_positions", {}))

## Преобразует словарь Vector2 в словарь.
func _vector2_dict_to_dict(vec_dict: Dictionary) -> Dictionary:
	var result = {}
	for key in vec_dict:
		result[key] = { "x": vec_dict[key].x, "y": vec_dict[key].y }
	return result

## Преобразует словарь в словарь Vector2.
func _dict_to_vector2_dict(dict: Dictionary) -> Dictionary:
	var result = {}
	for key in dict:
		result[key] = _dict_to_vector2(dict[key])
	return result

## Преобразует словарь в Vector2.
func _dict_to_vector2(dict: Dictionary) -> Vector2:
	if dict.is_empty():
		return Vector2.ZERO
	return Vector2(dict.get("x", 0), dict.get("y", 0))

## Преобразует словарь Vector2i.
func _dict_to_vector2i(dict: Dictionary) -> Vector2:
	if dict.is_empty():
		return Vector2i.ZERO
	return Vector2i(dict.get("x", 0), dict.get("y", 0))

## Преобразует Vector2 в словарь.
func _vector2_to_dict(vec: Vector2) -> Dictionary:
	return {
		"x": float(vec.x),
		"y": float(vec.y)
	}

## Сохраняем TileMap.
func save_tilemap_data(tilemap: TileMap) -> void:
	tilemap_data = {}
	##  Проходим по всем слоям TileMap
	for layer in range(tilemap.get_layers_count()):
		var layer_data = {}
		var used_cells = tilemap.get_used_cells(layer)
		for cell in used_cells:
			##  Создаем ключ в формате "x_y"
			var cell_key = "%d_%d" % [cell.x, cell.y]
			##  Получаем данные тайла
			var tile_data = tilemap.get_cell_tile_data(layer, cell)
			if tile_data:
				layer_data[cell_key] = {
					"source_id": tilemap.get_cell_source_id(layer, cell),
					"atlas_coords": _vector2_to_dict(tilemap.get_cell_atlas_coords(layer, cell)),
					"alternative_tile": tilemap.get_cell_alternative_tile(layer, cell)
			}
			tilemap_data["layer_%d" % layer] = layer_data

## Загружаем TileMap.
func restore_tilemap_data(tilemap: TileMap) -> void:
	##  Очищаем TileMap перед восстановлением
	tilemap.clear()
	for layer_key in tilemap_data:
		var layer_num = layer_key.replace("layer_", "").to_int()
		var layer_data = tilemap_data[layer_key]
		for cell_key in layer_data:
			var coords = cell_key.split("_")
			var cell_pos = Vector2i(int(coords[0]), int(coords[1]))
			var tile_info = layer_data[cell_key]
			##  Восстанавливаем тайл
			tilemap.set_cell(
				layer_num,
				cell_pos,
				tile_info.source_id,
				_dict_to_vector2i(tile_info.atlas_coords),
				tile_info.alternative_tile
			)
