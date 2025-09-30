extends Area2D

## При столкновении с игроком испускается сигнал.
signal touched

func _ready() -> void:
	add_to_group("enemyAreas")

func _on_body_entered(body: Node2D):
	if body is CharacterBody2D and body.get_script() == preload("res://Scripts/player_char.gd"):
		emit_signal("touched")
