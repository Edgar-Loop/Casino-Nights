extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var player_nearby := false

func _ready() -> void:
	$interact_area.body_entered.connect(_on_body_entered)
	$interact_area.body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
		if player_nearby and Input.is_action_just_pressed("Interact"):
			animated_sprite_2d.play("Open")
			await animated_sprite_2d.animation_finished
			animated_sprite_2d.play("Close")
			await animated_sprite_2d.animation_finished
			get_tree().change_scene_to_file("res://Scenes/endimage.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
