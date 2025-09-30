extends GameState
class_name PlayingState

## Основное состояние игры

## Включаем игровое UI, активируем движения противников и игрока
func enter() -> void:
	Engine.time_scale = 1.0
	
	get_tree().call_group("ui", "show_game_ui")
	
	get_tree().call_group("player", "set_process_input", true)
	get_tree().call_group("enemies", "set_process", true)

func exit() -> void:
	get_tree().call_group("ui", "hide_game_ui")

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		state_machine.change_state("Paused")

func update(delta: float) -> void:
	check_game_over_conditions()

## Проверяем, выполнены ли условия для победы или поражения.
func check_game_over_conditions() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player and player.lives <= 0:
		state_machine.change_state("GameOver")
		return
	
	var coins = get_tree().get_nodes_in_group("coins")
	if coins.size() == 0:
		state_machine.change_state("LevelComplete")
		return

func get_state_name() -> String:
	return "Playing"
