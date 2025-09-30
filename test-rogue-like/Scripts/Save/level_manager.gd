extends Node

@onready var tile_map: TileMap = $"../TileMap"
@onready var manager: Node2D = $".."

## Левел менеджер следит за сохранениями и загрузкой
func _ready() -> void:
	add_to_group("level_manager")

## Возвращает все необходимые данные для сохранения.
func collect_save_data() -> SaveData:
	var save_data = SaveData.new()
	save_data.score = $"..".score
	
	## Сохраняем игрока
	var player = get_tree().get_first_node_in_group("player")
	var playerData = player.get_save_data()
	save_data.player_lives = playerData.lives
	save_data.player_position = playerData.position
	
	## Сохраняем монеты
	var coins = get_tree().get_nodes_in_group("coins")
	var coinsData: Dictionary = {}
	for coin in coins:
		coinsData[coinsData.size()+1] = coin.get_save_data()
	save_data.coins_positions = coinsData
	
	## Сохраняем противников
	var enemies = get_tree().get_nodes_in_group("enemies")
	var enemiesData: Dictionary = {}
	for enemy in enemies:
		enemiesData[enemiesData.size()+1] = enemy.get_save_data()
	save_data.ghosts_positions = enemiesData
	
	## Сохраняем карту
	save_data.save_tilemap_data(tile_map)
	
	return save_data

## Загружает все содержимое сохранения.
func load_save_data(save_data: SaveData) -> void:
	$"..".score = save_data.score
	
	## Загружаем игрока
	var player = get_tree().get_first_node_in_group("player")
	player.lives = save_data.player_lives
	player.global_position = save_data.player_position
	
	## Загружаем карту
	save_data.restore_tilemap_data(tile_map)
	tile_map.generate_collisions()
	
	## Загружаем противников
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.queue_free()
	for key in save_data.ghosts_positions:
		var ghost_scene = preload("res://Scenes/ghost.tscn")
		var ghost_instance = ghost_scene.instantiate()
		ghost_instance.position = save_data.ghosts_positions[key]
		ghost_instance.scale = Vector2.ONE * 1.5
		add_child(ghost_instance)
	
	## Загружаем монеты
	var coins = get_tree().get_nodes_in_group("coins")
	for coin in coins:
		coin.queue_free()
	for key in save_data.coins_positions:
		var coin_scene = preload("res://Scenes/coins.tscn")
		var coin_instance = coin_scene.instantiate()
		coin_instance.position = save_data.coins_positions[key]
		coin_instance.scale = Vector2.ONE * 1.5
		add_child(coin_instance)
	
	## Подключаем их сигналы
	manager.connect_to_coins()
	manager.connect_to_enemies()
