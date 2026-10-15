extends Node2D

@onready var machine: AnimatedSprite2D = $AnimatedSprite2D
@onready var interact_area: Area2D = $Interact_area

var hidden_player = null
var busy: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if busy or not event.is_action_pressed("Interact"):
		return
	
	if is_instance_valid(hidden_player):
		get_viewport().set_input_as_handled()
		Not_hide()
		return
	
	for body in interact_area.get_overlapping_bodies():
		if body.is_in_group("player") and not body.is_hiding:
			get_viewport().set_input_as_handled()
			Hide(body)
			return

func Hide (player) -> void:
	busy = true
	hidden_player = player
	player.enter_hiding()
		
	machine.play("Hidden")
	busy = false
	
func Not_hide() -> void:
	busy = true
	machine.play("Normal")
	hidden_player.exit_hiding()
	hidden_player = null
	busy = false
