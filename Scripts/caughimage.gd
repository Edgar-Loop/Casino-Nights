extends Node2D


@export var time_before_return: float = 3.0

func _ready() -> void:

	await get_tree().create_timer(time_before_return).timeout
	
	get_tree().change_scene_to_file("res://Scenes/prototype.tscn")
