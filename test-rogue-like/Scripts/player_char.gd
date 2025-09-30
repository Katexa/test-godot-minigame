extends CharacterBody2D
## Скорость игрока.
@export var speed: int = 100 
## Количество жизней игрока.
@export var lives: int = 1 
## Скорость дэша.
@export var dash_speed: int = 400 
## Время дэша.
@export var dash_duration: float = 0.3 
## Время отката дэша.
@export var dash_reload: float = 1.0 

var current_direction: Vector2 = Vector2.ZERO
var input_direction: Vector2 = Vector2.ZERO
var current_speed: int = speed
var is_dashing: bool = false
var can_dash: bool = true
var dash_direction: Vector2 = Vector2.ZERO

## Скрипт игрока

func _ready():
	add_to_group("player")
	collision_layer = 2
	collision_mask = 1

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if Engine.time_scale > 0.0:
		handle_input()

## Следит за вводом.
func handle_input():
	input_direction = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		input_direction.x += 1
	elif Input.is_action_pressed("move_left"):
		input_direction.x -= 1
	elif Input.is_action_pressed("move_down"):
		input_direction.y += 1
	elif Input.is_action_pressed("move_up"):
		input_direction.y -= 1
	
	## Активируем dash в приоритете
	if Input.is_action_just_pressed("dash") and can_dash:
		start_dash()
	
	## Нормализуем скорость, если двигаемся по диагонали
	if input_direction.length() > 0:
		input_direction = input_direction.normalized()
	
	## Двигаемся, если не ускорены
	if not is_dashing:
		current_direction = Vector2.ZERO
		if input_direction != Vector2.ZERO:
			current_direction = input_direction
			rotation = current_direction.angle()
	velocity = current_direction * current_speed
	move_and_slide()

## Активирует дэш, таймер действия дэша и затем таймер отката дэша.
func start_dash():
	is_dashing = true
	can_dash = false
	current_speed = dash_speed
	await get_tree().create_timer(dash_duration).timeout
	current_speed = speed
	is_dashing = false
	
	await get_tree().create_timer(dash_reload).timeout
	can_dash = true

func get_save_data() -> Dictionary:
	return {
		"position": global_position,
		"lives": lives
	}
