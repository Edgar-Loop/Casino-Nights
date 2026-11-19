extends Node2D

@onready var door_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interact_area: Area2D = $interact_area

@onready var enter_point: Marker2D = $EnterPoint
@onready var exit_point: Marker2D = $ExitPoint

@export var is_closet_exit: bool = false
@export var closet_scene: PackedScene

var player_camera: Camera2D

var other_door: Node2D = null
var closet_instance: Node2D = null
var busy: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if busy or not event.is_action_pressed("Interact"):
		return

	for body in interact_area.get_overlapping_bodies():
		if not body.is_in_group("player"):
			continue

		if is_closet_exit:
			if is_instance_valid(other_door):
				get_viewport().set_input_as_handled()
				leave_room(body)

		elif not body.is_hiding:
			get_viewport().set_input_as_handled()
			enter_room(body)

		return

func enter_room(player) -> void:
	busy = true

	player_camera = player.get_node("Camera2D")

	player.enter_hiding()

	door_sprite.play("door_opening")
	await door_sprite.animation_finished

	if closet_scene == null:
		push_error("No closet scene assigned to the outside door!")
		player.exit_hiding()
		door_sprite.play("door_closing")
		await door_sprite.animation_finished
		door_sprite.play("closed")
		busy = false
		return

	closet_instance = closet_scene.instantiate()
	get_tree().current_scene.add_child(closet_instance)

	closet_instance.global_position = global_position + Vector2(0, -320)

	var inside_door = closet_instance.find_child(
		"janitor_door", true, false
	) as Node2D

	if inside_door == null:
		push_error("Could not find janitor_door inside the closet!")
		closet_instance.queue_free()
		closet_instance = null
		player.exit_hiding()
		door_sprite.play("door_closing")
		await door_sprite.animation_finished
		door_sprite.play("closed")
		busy = false
		return

	other_door = inside_door
	inside_door.set("other_door", self)
	inside_door.set("closet_instance", closet_instance)

	var closet_camera = closet_instance.get_node("janitor_cam") as Camera2D

	if closet_camera.limit_top != -1:
		closet_camera.limit_top -= 320

	if closet_camera.limit_bottom != -1:
		closet_camera.limit_bottom -= 320

	var destination = inside_door.get_node("EnterPoint") as Marker2D
	player.global_position = destination.global_position

	player.exit_hiding()

	door_sprite.play("door_closing")
	await door_sprite.animation_finished

	door_sprite.play("closed")

	player_camera.enabled = false

	closet_camera.reparent(player)

	closet_camera.position = Vector2.ZERO
	closet_camera.offset = Vector2.ZERO

	closet_camera.enabled = true
	closet_camera.make_current()
	closet_camera.reset_smoothing()

	busy = false

func leave_room(player) -> void:
	busy = true

	door_sprite.play("door_opening")
	await door_sprite.animation_finished

	var outside_door = other_door

	player.enter_hiding()

	var destination = outside_door.get_node("ExitPoint") as Marker2D
	player.global_position = destination.global_position

	player.exit_hiding()

	var outside_sprite = outside_door.get_node(
		"AnimatedSprite2D"
	) as AnimatedSprite2D

	outside_sprite.play("door_opening")
	await outside_sprite.animation_finished

	outside_sprite.play("door_closing")
	await outside_sprite.animation_finished

	outside_sprite.play("closed")

	var room_to_remove = closet_instance
	var closet_camera = player.get_node_or_null("janitor_cam")

	if is_instance_valid(closet_camera) and is_instance_valid(room_to_remove):
		closet_camera.enabled = false
		closet_camera.reparent(room_to_remove)

	outside_door.player_camera.enabled = true
	outside_door.player_camera.make_current()

	outside_door.set("other_door", null)
	outside_door.set("closet_instance", null)

	other_door = null
	closet_instance = null

	busy = false

	if is_instance_valid(room_to_remove):
		room_to_remove.queue_free()
