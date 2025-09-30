extends CharacterBody2D

@export var speed: int = 50
var movement_direction: Vector2 = Vector2.RIGHT
var possible_directions: Array = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]
var ghost_id: String = ""

## Призраки ходят с заданной скоростью в случайном направлении из заданных в possible_directions
## По истечению таймера в 2 секунды или при столкновении со стеной призрак меняет направление движения 
func _ready():
	add_to_group("enemies")
	collision_layer = 2
	collision_mask = 1
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 2.0
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	if ghost_id.is_empty(): #id для сохранений
		ghost_id = "ghost_%d" % get_instance_id()

func _physics_process(delta):
	velocity = movement_direction * speed
	move_and_slide()
	if get_last_slide_collision() != null:
		choose_new_direction()

## Вызывает необходимые методы по истечении таймера.
func _on_timer_timeout():
	choose_new_direction()

## Выбирает новое случайное направление для противника.
func choose_new_direction():
	movement_direction = possible_directions[randi() % possible_directions.size()]

func get_save_data() -> Vector2:
	return global_position

func load_save_data(data: Dictionary) -> void:
	global_position = data.position
