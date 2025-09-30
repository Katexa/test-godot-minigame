extends CanvasLayer

@onready var game_ui = $GameUI
@onready var pause_menu = $PauseMenu
@onready var game_over_menu = $EndGameMenu
@onready var game_over_label = $EndGameMenu/VBoxContainer/Label

func _ready() -> void:
	add_to_group("ui")

## Показывает игровое UI.
func show_game_ui():
	game_ui.visible = true

## Скрывает игровое UI.
func hide_game_ui():
	game_ui.visible = false

## Показывает UI паузы.
func show_pause_menu():
	pause_menu.visible = true

## Скрывает UI паузы.
func hide_pause_menu():
	pause_menu.visible = false

## Показывает UI конца игры.
func show_game_over():
	game_over_menu.visible = true
	game_over_label.text = "Поражение"
	game_ui.visible = false

## Показывает UI победы.
func show_level_complete():
	game_over_menu.visible = true
	game_over_label.text = "Победа!"
	game_ui.visible = false

## Реализует логику при нажатии кнопки сохранения.
func _on_save_button_pressed():
	get_tree().call_group("game_state", "save_game")

## Реализует логику при нажатии кнопки загрузки.
func _on_load_button_pressed():
	get_tree().call_group("game_state", "load_game")
