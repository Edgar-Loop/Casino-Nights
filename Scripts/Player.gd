extends CharacterBody2D

signal hiding_changed(is_hiding: bool)

@export var speed := 80
@export var dash_speed: float = 180
@export var dash_duration: float = .15
@export var dash_cooldown: float = 1

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var normal_collision_layer: int
var has_mask: bool = false
var is_mask: bool = false
var is_hiding: bool = false
var dash_time_left: float = 0
var cooldown_time_left: float = 0
var dash_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	normal_collision_layer = collision_layer
	
func _physics_process(delta: float) -> void:
	dash_time_left = maxf(dash_time_left - delta, 0.0)
	cooldown_time_left = maxf(cooldown_time_left - delta, 0.0)

	if is_hiding:
		velocity = Vector2.ZERO
		return

	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	
	if Input.is_action_just_pressed("Dash"):
		if cooldown_time_left <= 0 and direction != Vector2.ZERO:
			dash_direction = direction.normalized()
			dash_time_left = dash_duration
			cooldown_time_left = dash_cooldown
			
	if dash_time_left > 0.0:
		velocity = dash_direction * dash_speed
	else:
		velocity = direction * speed
	
	if is_mask:
		if velocity != Vector2.ZERO:
			animated_sprite_2d.play("walkMask")
		else:
			animated_sprite_2d.play("idleMask")
	else:
		if velocity != Vector2.ZERO:
			animated_sprite_2d.play("walk")
		else:
			animated_sprite_2d.play("idle")
	if velocity.x != 0.0:
		animated_sprite_2d.flip_h = velocity.x < 0.0
	move_and_slide()
			
	if Input.is_action_just_pressed("Mask"):
		is_mask = !is_mask

func enter_hiding() -> void:
	is_hiding = true
	dash_time_left = 0
	velocity = Vector2.ZERO
	animated_sprite_2d.hide()
	set_hiding(true)
	collision_layer = 0
	
func exit_hiding() -> void:
	is_hiding = false
	animated_sprite_2d.show()
	animated_sprite_2d.play("idle")
	set_hiding(false)
	collision_layer = normal_collision_layer
	
func set_hiding(value: bool):
	if is_hiding == value:
		return
	is_hiding = value
	hiding_changed.emit(is_hiding)
