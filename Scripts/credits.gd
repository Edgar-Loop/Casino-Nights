extends Node2D

@onready var Return: Button = $Return


func _ready() -> void:
	Return.pressed.connect(_on_return_pressed)

func _process(delta: float) -> void:
	pass

func _on_return_pressed():
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
