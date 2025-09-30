extends TileMap

## Ширина генерируемой карты.
## Нечетное для корректной работы.
@export_range(21, 41, 2) var width: int = 31  

## Высота генерируемой карты.
## Нечетное для корректной работы.
@export_range(21, 41, 2) var height: int = 31

## Координата тайла стены в атласе.
var WALL_TILE: Vector2i = Vector2i(6, 1)
## Координата тайла пола в атласе.
var FLOOR_TILE: Vector2i = Vector2i(1, 1)

func _ready():
	generate_maze()
	create_player(1, 1)
	create_ghost(1, height - 2)
	create_ghost(width - 2, 1)
	create_ghost(width - 2, height - 2)
	$"..".connect_to_coins()
	$"..".connect_to_enemies()

## Генерирует карту
func generate_maze():
	fill_with_walls()
	var start_x = 1
	var start_y = 1
	set_passage(start_x, start_y)
	set_cell(0, Vector2i(1, 1),  0, FLOOR_TILE)
	set_cell(0, Vector2i(width-2, height-2),  0, FLOOR_TILE)
	generate_collisions()

## ЗАполняет карту тайлами стен.
func fill_with_walls():
	for x in range(width):
		for y in range(height):
			set_cell(0, Vector2i(x, y), 0, WALL_TILE)

## "Прорубает" проходы в стенах.
## Заменяет некоторые тайлы стен тайлами пола. 
func set_passage(x:int, y:int):
	set_cell(0, Vector2i(x, y),  0, FLOOR_TILE)
	
	var directions = [
		Vector2i(2, 0),
		Vector2i(-2, 0),
		Vector2i(0, 2),
		Vector2i(0, -2),
	]
	directions.shuffle()
	for direction in directions:
		var new_x = x + direction.x
		var new_y = y + direction.y
		
		if (new_x > 0 and new_x < width - 1 and
			new_y > 0 and new_y < height - 1 and
			get_cell_atlas_coords(0, Vector2i(new_x, new_y)) == WALL_TILE):
			
			var wall_x = x + direction.x / 2
			var wall_y = y + direction.y / 2
			set_cell(0, Vector2i(wall_x, wall_y), 0, FLOOR_TILE)
			if (randi() % 5 == 0): ## 20% шанс создать монетку
				create_coin(x, y)
			elif randi() % 10 == 0: ## 10% шанс создать призрака
				create_ghost(x, y)
				
			## Добавим чуть чуть свободных клеток в лабиринт-кишки
			if (wall_y > 1 and randi() % 5 == 0 and
				get_cell_atlas_coords(0, Vector2i(wall_x, wall_y - 1)) == WALL_TILE):
				set_cell(0, Vector2i(wall_x, wall_y-1), 0, FLOOR_TILE)
			if (wall_x > 1 and randi() % 5 == 0 and
				get_cell_atlas_coords(0, Vector2i(wall_x - 1, wall_y)) == WALL_TILE):
				set_cell(0, Vector2i(wall_x -1, wall_y), 0, FLOOR_TILE)
			if (wall_y < height - 2 and randi() % 5 == 0 and
				get_cell_atlas_coords(0, Vector2i(wall_x, wall_y + 1)) == WALL_TILE):
				set_cell(0, Vector2i(wall_x, wall_y+1), 0, FLOOR_TILE)
			if (wall_x < width - 2 and randi() % 5 == 0 and
				get_cell_atlas_coords(0, Vector2i(wall_x + 1, wall_y)) == WALL_TILE):
				set_cell(0, Vector2i(wall_x + 1, wall_y), 0, FLOOR_TILE)
			
			## Делаем это рекурсивно
			set_passage(new_x, new_y)

## Создает монету по указанным координатам.
func create_coin(x:int, y:int):
	var dot_scene = preload("res://Scenes/coins.tscn")
	var dot_instance = dot_scene.instantiate()
	dot_instance.position = map_to_local(Vector2i(x, y))
	add_child(dot_instance)

## Создает игрока по указанным координатам.
func create_player(x:int, y:int):
	var player_scene = preload("res://Scenes/player_char.tscn")
	var player_instance = player_scene.instantiate()
	player_instance.position = map_to_local(Vector2i(x, y))
	add_child(player_instance)

## Создает противника по указанным координатам.
func create_ghost(x:int, y:int):
	var ghost_scene = preload("res://Scenes/ghost.tscn")
	var ghost_instance = ghost_scene.instantiate()
	ghost_instance.position = map_to_local(Vector2i(x, y))
	add_child(ghost_instance)

## Создает коллизию для стен.
func generate_collisions():
	clear_collisions()
	var wall_body = StaticBody2D.new()
	wall_body.add_to_group("wall_collisions")
	add_child(wall_body)
	
	for x in range(width):
		for y in range(height):
			if get_cell_atlas_coords(0, Vector2i(y, x)) == WALL_TILE:
				var collision = CollisionShape2D.new()
				var shape = RectangleShape2D.new()
				var tile_size = tile_set.tile_size
				shape.size = tile_size
				collision.shape = shape
				collision.position = map_to_local(Vector2i(y, x))
				wall_body.add_child(collision)

## Обнуляет коллизию стен.
func clear_collisions():
	var collision_bodies = get_tree().get_nodes_in_group("wall_collisions")
	for body in collision_bodies:
		body.queue_free()
