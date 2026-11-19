extends Node2D

@export var time_before_return: float = 4.0

@onready var loser: AudioStreamPlayer = $Loser

func _ready() -> void:
	Music.stop()
	loser.play()
	await get_tree().create_timer(time_before_return).timeout
	
	Music.play()
	var current_scene = Levelmanager.level_scenes[Levelmanager.current_level]
	get_tree().change_scene_to_file(current_scene)
