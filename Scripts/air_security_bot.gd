extends CharacterBody2D

@export var speed: float = 40.0
@export var patrol_distance: float = 200.0

@onready var scan_area: Area2D = $ScanArea
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var start_x: float
var direction: float = 1.0

func _ready() -> void:
	start_x = global_position.x
	scan_area.body_entered.connect(_on_scan_area_body_entered)

func _physics_process(_delta: float) -> void:
	if global_position.x >= start_x + patrol_distance:
		direction = -1.0
	elif global_position.x <= start_x - patrol_distance:
		direction = 1.0

	velocity.x = direction * speed
	velocity.y = 0.0

	move_and_slide()

	animated_sprite.flip_h = direction < 0

func _on_scan_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	if body.get("is_hiding") == true:
		return
		
	print("Drone detected player! Alerting all robots.")

	get_tree().call_group("robots", "investigate", global_position)
