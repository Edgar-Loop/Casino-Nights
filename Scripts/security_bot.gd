extends CharacterBody2D

@export var speed: float = 40
@export var patrol_distance: float = 150

@onready var lose_target_timer: = $LoseTargetTimer
@onready var scan_area: Area2D = $ScanArea
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var body_collision: CollisionShape2D = $CollisionShape2D

@onready var tase_area: Area2D = $TaseArea

var chase_target: Node2D = null
var body_right_x: float
var start_x: float
var moving_right: bool = true
var scan_right_x: float

func _ready() -> void:
	start_x = global_position.x
	scan_right_x = scan_area.position.x
	animated_sprite.play("move_right")
	
	$TaseArea.body_entered.connect(_on_body_entered)
	
func _physics_process(delta: float) -> void:
	if is_instance_valid(chase_target):
		velocity = global_position.direction_to(chase_target.global_position) * speed
		if velocity.x < 0 and moving_right:
			moving_right = false
			animated_sprite.play("move_left")
			animated_sprite.position.x = -30
			scan_area.position.x = scan_right_x - 48
			body_collision.position.x = scan_right_x - 12 
		elif velocity.x > 0 and not moving_right:
			moving_right = true
			animated_sprite.play("move_right")
			animated_sprite.position.x = 10
			scan_area.position.x = scan_right_x
			body_collision.position.x = body_right_x - 8
		move_and_slide()
		return
	
	var target_x: float = start_x + patrol_distance

	if not moving_right:
		target_x = start_x - patrol_distance
	var patrol_motion = Vector2(sign(target_x - global_position.x) * speed * delta, 0.0)
	var blocked = test_move(global_transform, patrol_motion)
	if abs(global_position.x - target_x) < 5 or blocked: 
		moving_right = not moving_right
		
		
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

	velocity = Vector2(sign(target_x - global_position.x) * speed, 0.0)
	move_and_slide()

func _on_scan_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		chase_target = body
		lose_target_timer.stop()
		print("Player Entered Scan Area")

func _on_scan_area_body_exited(body: Node2D) -> void:
	if body == chase_target:
		lose_target_timer.start()

func _on_lose_target_timer_timeout() -> void:
	chase_target = null

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://Scenes/caughimage.tscn")
