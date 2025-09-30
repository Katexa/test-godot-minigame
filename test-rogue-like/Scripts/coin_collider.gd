extends Area2D

signal collected

## id для сохранений.
var coin_id: String = ""

func _ready(): 
	add_to_group("coins")
	if coin_id.is_empty(): 
		coin_id = "coin_%d" % get_instance_id()

## Отслеживаем коллизию с игроком и отправляем сигнал "collected"
func _on_body_entered(body: Node2D): 
	if body is CharacterBody2D and body.get_script() == preload("res://Scripts/player_char.gd"):
		emit_signal("collected")
		queue_free()

## Возвращает позицию монеты
func get_save_data() -> Vector2:
	return global_position

## Загружает позицию монеты
func load_save_data(data: Dictionary) -> void:
	global_position = data.position
