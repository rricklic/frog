class_name Item extends Sprite2D


@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node) -> void:
	if (body is Player):
		(body as Player).add_item("Ball")
		queue_free()
