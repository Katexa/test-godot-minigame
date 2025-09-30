extends Control

## Реализаует логику при нажатии кнопки вызвращения в игру.
func _on_resume_button_pressed() -> void:
	get_tree().call_group("game_state", "resume_game")

## Реализует логику при нажатии кнопки загрузки.
func _on_load_button_pressed() -> void:
	var save_data = SaveManager.load_game()
	if save_data:
		var level_manager = get_tree().get_first_node_in_group("level_manager")
		if level_manager:
			level_manager.load_save_data(save_data)

## Реализует логику при нажатии конпки сохранения и выхода.
func _on_save_quit_button_pressed() -> void:
	var level_manager = get_tree().get_first_node_in_group("level_manager")
	if level_manager:
		var save_data = level_manager.collect_save_data()
		SaveManager.save_game(save_data)
	get_tree().quit()
