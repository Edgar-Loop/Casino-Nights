extends Area2D

@export var item_name: String = "Taser"
@export var item_texture: Texture2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:

	if not body.is_in_group("player"):
		return

	if body.has_method("show_pickup_notification"):
		body.show_pickup_notification(item_name, item_texture)

	queue_free()
