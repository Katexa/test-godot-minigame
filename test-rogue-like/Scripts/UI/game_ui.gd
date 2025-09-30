extends Control

@onready var score_label: Label = $HBoxContainer/ScoreValue
@onready var to_win_label: Label = $HBoxContainer2/ScoreValue
@onready var manager: Node2D = $"../.."

func _ready():
	manager.score_updated.connect(update_score) ## подписываемся на изменение игрового счета
	update_score(0)
	to_win_label.text = str(manager.max_coins_for_win)

## Обновляет счет игрока на экране.
func update_score(new_score: int):
	score_label.text = str(new_score)

## Реализует логику при нажатии кнопки паузы.
func _on_pause_button_pressed() -> void:
	get_tree().call_group("game_state", "pause_game")

## Реализует логику при нажатии кнопки сохранения.
func _on_save_button_pressed() -> void:
	var level_manager = get_tree().get_first_node_in_group("level_manager")
	if level_manager:
		var save_data = level_manager.collect_save_data()
		SaveManager.save_game(save_data)

## Реализует логику при нажатии кнопки загрузки.
func _on_load_button_pressed() -> void:
	var save_data = SaveManager.load_game()
	if save_data:
		var level_manager = get_tree().get_first_node_in_group("level_manager")
		if level_manager:
			level_manager.load_save_data(save_data)
