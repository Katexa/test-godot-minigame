extends GameState
class_name LevelCompleteState

## При входе в состояние победы скрываем игровое UI, показываем победное UI.
## Также останавливаем движение игрока и противников.
func enter() -> void:
	Engine.time_scale = 0.0
	get_tree().call_group("player", "set_process", false)
	get_tree().call_group("ui", "show_level_complete")
	get_tree().call_group("enemies", "set_process", false)

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		load_next_level()

## Тут можно прописать логику загрузки нового уровня. 
## Генерирует новую карту.
func load_next_level() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()

func get_state_name() -> String:
	return "LevelComplete"
