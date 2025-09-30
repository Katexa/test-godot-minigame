extends GameState
class_name GameOverState

func enter() -> void:
	Engine.time_scale = 0.0
	get_tree().call_group("player", "set_process", false)
	get_tree().call_group("enemies", "set_process", false)
	
	get_tree().call_group("ui", "show_game_over")

func update(delta: float) -> void:
	get_tree().call_group("ui", "show_restart_menu")

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("restart"):
		restart_game()

func restart_game() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()

func get_state_name() -> String:
	return "GameOver"
