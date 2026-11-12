extends Area2D


@export var item_id: String = "black_chip"
@export var amount: int = 1


func _physics_process(_delta: float) -> void:
	var nearby_player: Node2D = null

	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			nearby_player = body
			break

	$PickupPrompt.visible = nearby_player != null

	if nearby_player != null:
		if Input.is_action_just_pressed("Interact"):
			collect(nearby_player)



func collect(player: Node2D) -> void:
	var items: Dictionary = player.get_meta("collected_items", {})

	items[item_id] = items.get(item_id, 0) + amount
	player.set_meta("collected_items", items)

	print("Picked up: ", item_id, " | Total: ", items[item_id])
	queue_free()
