extends Node2D

@export var item_scene: PackedScene
@export_range(0.0, 100.0) var spawn_chance_percent: float = 100.0

@onready var spawn_point: Marker2D = $SpawnItem

func _ready() -> void:
	call_deferred("try_spawn")

func try_spawn() -> void:

	if randf() >= spawn_chance_percent / 100.0:
		return

	if item_scene == null:
		push_warning("No item scene assigned to LootSpawner!")
		return

	var item = item_scene.instantiate()
	get_parent().add_child(item)
	item.global_position = spawn_point.global_position
