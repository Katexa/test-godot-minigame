class_name GameStateMachine
extends Node

## Меняем состояния игры через эту машину, при смене состояния исускаем сигнал
signal state_changed(new_state_name)

var current_state: GameState
var states: Dictionary = {}

func _ready():
	add_to_group("game_state")
	for child in get_children():
		if child is GameState:
			child.state_machine = self
			states[child.get_state_name()] = child
	
	change_state("Playing")

func change_state(state_name: String) -> void:
	if not states.has(state_name):
		return
	
	if current_state:
		current_state.exit()
	
	current_state = states[state_name]
	current_state.enter()
	
	emit_signal("state_changed", state_name)

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

## Вход в состояние паузы.
func pause_game() -> void:
	change_state("Paused")

## Вход в состояние игры.
func resume_game() -> void:
	change_state("Playing")

## Вход в состояние конца игры.
func game_end() -> void:
	change_state("GameOver")

## Вход в состояние игры.
func restart_game() -> void:
	change_state("Playing")

## Проверка является ли активное состояние состоянием игры.
func is_playing() -> bool:
	return current_state.get_state_name() == "Playing"

## Проверка является ли активное состояние состоянием паузы.
func is_paused() -> bool:
	return current_state.get_state_name() == "Paused"
