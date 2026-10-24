extends CharacterBody2D

@export var speed: float = 60
@export var patrol_distance: float = 150

@onready var lose_target_timer = $LoseTargetTimer
@onready var scan_area: Area2D = $ScanArea
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var body_collision: CollisionShape2D = $CollisionShape2D
@onready var tase_area: Area2D = $TaseArea

var investigating: bool = false
var investigation_target: Vector2 = Vector2.ZERO

var chase_target: Node2D = null
var tracked_player: Node2D = null
var body_right_x: float
var start_x: float
var moving_right: bool = true
var scan_right_x: float
var vertical_direction: float = 1
var vertical_speed: float = 20
var vertical_timer: float = 0

func _ready() -> void:
	start_x = global_position.x
	scan_right_x = scan_area.position.x
	body_right_x = body_collision.position.x

	animated_sprite.play("move_right")
	tase_area.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if investigating:
		var distance_to_target = global_position.distance_to(investigation_target)

		if distance_to_target < 10.0:
			investigating = false
			velocity = Vector2.ZERO
			move_and_slide()
			return

		var direction_to_target = global_position.direction_to(investigation_target)
		velocity = direction_to_target * speed
		if velocity.x < 0 and moving_right:
			moving_right = false
			animated_sprite.play("move_left")
			animated_sprite.position.x = -30
			scan_area.position.x = scan_right_x - 48
			body_collision.position.x = body_right_x - 12

		elif velocity.x > 0 and not moving_right:
			moving_right = true
			animated_sprite.play("move_right")
			animated_sprite.position.x = 10
			scan_area.position.x = scan_right_x
			body_collision.position.x = body_right_x - 8

		move_and_slide()
		return

	vertical_timer += delta

	if vertical_timer >= 0.75:
		vertical_timer = 0
		vertical_direction *= -1

	var target_x: float = start_x + patrol_distance

	if not moving_right:
		target_x = start_x - patrol_distance

	var patrol_motion = Vector2(
		sign(target_x - global_position.x) * speed,
		vertical_direction * vertical_speed
	) * delta

	var blocked = test_move(global_transform, patrol_motion)

	if abs(global_position.x - target_x) < 5 or blocked:
		moving_right = not moving_right
		vertical_direction *= -1

		if moving_right:
			animated_sprite.play("move_right")
			animated_sprite.position.x = 10
			scan_area.position.x = scan_right_x
			body_collision.position.x = body_right_x - 8
		else:
			animated_sprite.play("move_left")
			animated_sprite.position.x = -30
			scan_area.position.x = scan_right_x - 48
			body_collision.position.x = body_right_x - 12

		return

	velocity = Vector2(
		sign(target_x - global_position.x) * speed,
		vertical_direction * vertical_speed
	)
	move_and_slide()

func _on_scan_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	tracked_player = body

	if not body.hiding_changed.is_connected(_on_player_hiding_changed):
		body.hiding_changed.connect(_on_player_hiding_changed)

	if body.is_hiding:
		return

func _on_scan_area_body_exited(body: Node2D) -> void:
	if body == chase_target:
		lose_target_timer.start()

func _on_lose_target_timer_timeout() -> void:
	chase_target = null

func _on_player_hiding_changed(is_hiding: bool) -> void:
	if is_hiding:
		chase_target = null
		lose_target_timer.stop()
		print("Player is hiding!")
	else:
		print("Player is no longer hiding!")

		if is_instance_valid(tracked_player):
			if scan_area.overlaps_body(tracked_player):
				chase_target = tracked_player
				lose_target_timer.stop()

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	if body.is_hiding:
		return

	get_tree().change_scene_to_file("res://Scenes/caughimage.tscn")

func investigate(target_position: Vector2) -> void:
	investigation_target = target_position
	investigating = true

	chase_target = null
	lose_target_timer.stop()

	print("Robot 3 moving")
