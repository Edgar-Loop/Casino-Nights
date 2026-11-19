extends Node

var current_level: int = 0

var level_scenes: Array[String] = [
	"res://Levels/first_floor.tscn",
	"res://Levels/second_floor.tscn",
	"res://Levels/third_floor.tscn",
	"res://Levels/fourth_floor.tscn"
]

func go_to_next_level() -> void:

	var next_level = current_level + 1

	if next_level >= level_scenes.size():
		print("You reached the final level!")
		return

	var next_scene = level_scenes[next_level]

	if ResourceLoader.exists(next_scene):

		current_level = next_level

		print("Entering level: ", current_level + 1)
		print("Loading scene: ", next_scene)

		get_tree().change_scene_to_file(next_scene)

	else:
		print("Scene does not exist: ", next_scene)
