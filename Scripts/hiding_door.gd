extends Node2D

@onready var door_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interact_area: Area2D = $interact_area

var hidden_player = null
var busy: bool = false



func _unhandled_input(event: InputEvent) -> void:
	if busy or not event.is_action_pressed("Interact"):
		return
	
	if is_instance_valid(hidden_player):
		get_viewport().set_input_as_handled()
		leave_room()
		return
	
	for body in interact_area.get_overlapping_bodies():
		if body.is_in_group("player") and not body.is_hiding:
			get_viewport().set_input_as_handled()
			enter_room(body)
			return
func enter_room(player) -> void:
	busy = true
	hidden_player = player
	player.enter_hiding()
	
	door_sprite.play("door_opening")
	await door_sprite.animation_finished
	
	door_sprite.play("door_closing")
	await door_sprite.animation_finished
	
	door_sprite.play("closed")
	busy = false
	
func leave_room() -> void:
	busy = true
	door_sprite.play("door_opening")
	await door_sprite.animation_finished
	
	hidden_player.exit_hiding()
	hidden_player = null
	
	door_sprite.play("door_closing")
	await door_sprite.animation_finished
	
	door_sprite.play("closed")
	busy = false
