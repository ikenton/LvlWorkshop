extends Area2D

onready var Player = get_node("/Platform/Level/Player")
func _on_Area2D_body_entered(body):
	if body == Player:
		get_tree().reload_current_scene()
