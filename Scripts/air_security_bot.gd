extends CharacterBody2D

@export var speed: float = 40.0
@export var patrol_distance: float = 200.0
@export var min_turn_time: float = 1.5
@export var max_turn_time: float = 4.0

@export var max_hearing_distance: float = 200.0
@export var quiet_volume_db: float = -30.0
@export var loud_volume_db: float = -10.0

@onready var scan_area: Area2D = $ScanArea
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sound: AudioStreamPlayer = $Airdroneflyingsound

var start_x: float
var direction: float = 1.0
var turn_timer: float = 0.0
var next_turn_time: float = 2.0

var player: Node2D = null

func _ready() -> void:
	sound.play()
	sound.volume_db = quiet_volume_db

	start_x = global_position.x

	# Find the player independently of ScanArea.
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0] as Node2D

	scan_area.body_entered.connect(_on_scan_area_body_entered)

	animated_sprite.play("Flying")

	randomize()
	next_turn_time = randf_range(min_turn_time, max_turn_time)

func _physics_process(delta: float) -> void:
	turn_timer += delta

	if turn_timer >= next_turn_time:
		direction *= -1.0
		turn_timer = 0.0
		next_turn_time = randf_range(min_turn_time, max_turn_time)

	if global_position.x >= start_x + patrol_distance:
		direction = -1.0
		turn_timer = 0.0
		next_turn_time = randf_range(min_turn_time, max_turn_time)

	elif global_position.x <= start_x - patrol_distance:
		direction = 1.0
		turn_timer = 0.0
		next_turn_time = randf_range(min_turn_time, max_turn_time)

	velocity.x = direction * speed
	velocity.y = 0.0
	move_and_slide()

	animated_sprite.flip_h = direction < 0

	update_sound_volume()

func update_sound_volume() -> void:
	if not is_instance_valid(player):
		sound.volume_db = quiet_volume_db
		return

	var distance = global_position.distance_to(player.global_position)

	var closeness = 1.0 - clampf(
		distance / max_hearing_distance,
		0.0,
		1.0
	)

	sound.volume_db = lerpf(
		quiet_volume_db,
		loud_volume_db,
		closeness
	)
	
func _on_scan_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	if body.get("is_hiding") == true:
		return

	print("Drone detected player! Alerting all robots.")

	get_tree().call_group("Robots", "investigate", body.global_position)
