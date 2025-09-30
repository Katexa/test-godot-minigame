extends Node2D
## Максимальное необходимое количетсво монет для победы.
##  Если на карте заспавнится меньше монет чем нужно, то для победы надо собрать все монеты.
@export var max_coins_for_win: int = 15  

@onready var state_machine: GameStateMachine = $GameStateMachine

## При изменении счета испускается сигнал.
signal score_updated(new_score)

## Текущий счет игрока.
var score: int = 0

## Основной скрипт сцены, следит за сигналами.

## Подключает сигналы монет.
func connect_to_coins():
	var coins = get_tree().get_nodes_in_group("coins")
	for coin in coins:
		coin.collected.connect(_on_coin_collected)

## Подключает сигналы противников.
func connect_to_enemies():
	var enemies = get_tree().get_nodes_in_group("enemyAreas")
	for enemy in enemies:
		enemy.touched.connect(_on_enemy_touched)

## Реализует логику при подборе монеты.
func _on_coin_collected():
	score += 1
	## Испускаем сигнал обновления счета
	emit_signal("score_updated", score)
	if score >= max_coins_for_win:
		state_machine.change_state("LevelComplete")

## Реализует логику при столкновении с врагом.
func _on_enemy_touched():
	var player = get_tree().get_first_node_in_group("player")
	player.lives -= 1

func _input(event):
	## Глобальная пауза (например, по Esc)
	if event.is_action_pressed("pause") and state_machine.is_playing():
		state_machine.pause_game()
