extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interact_area: Area2D = $interact_area

var player_nearby := false
var door_activating := false
var player: CharacterBody2D = null

func _ready() -> void:
	interact_area.body_entered.connect(_on_body_entered)
	interact_area.body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("Interact") and not door_activating:
		door_activating = true

		animated_sprite_2d.play("Open")
		await animated_sprite_2d.animation_finished

		if is_instance_valid(player):
			print("Hiding player!")
			player.enter_hiding()
		else:
			print("Player reference was lost!")

		animated_sprite_2d.play("Close")
		await animated_sprite_2d.animation_finished

		get_tree().change_scene_to_file("res://Scenes/endimage.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player entered door area!")
		player = body
		player_nearby = true

func _on_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		player_nearby = false
