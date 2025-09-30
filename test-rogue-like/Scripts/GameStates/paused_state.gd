extends GameState
class_name PausedState

## Состояние паузы

## При входе отключаем игровое UI и включаем UI паузы
## Останавливаем движения врагов и игрока
func enter() -> void:
	Engine.time_scale = 0.0
	
	get_tree().call_group("ui", "show_pause_menu")
	
	get_tree().call_group("player", "set_process_input", false)
	get_tree().call_group("enemies", "set_process", false)

func exit() -> void:
	get_tree().call_group("ui", "hide_pause_menu")

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		state_machine.change_state("Playing")

func get_state_name() -> String:
	return "Paused"
