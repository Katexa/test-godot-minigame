class_name GameState
extends Node
## Базовый класс для машины состояний 
## Описываем тут нужные функции, которые потом переопределим в наследниках

var state_machine: GameStateMachine

## Включает в себя методы, которые нужно активировать при входе в состояние.
func enter() -> void:
	pass

## Включает в себя методы, которые нужно активировать при выходе из состояния.
func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func handle_input(event: InputEvent) -> void:
	pass

## Возвращает название состояния.
func get_state_name() -> String:
	return "BaseState"
