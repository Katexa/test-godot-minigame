extends Control

## Реализует логику при нажатии кнопки рестарта.
func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()

## Реализует логику при нажатии кнопки выхода.
func _on_quit_button_pressed() -> void:
	get_tree().quit()
