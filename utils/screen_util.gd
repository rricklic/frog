class_name ScreenUtil extends RefCounted

static func get_window_size(node: Node2D) -> Vector2:
	return node.get_tree().root.size
	
static func get_viewport_size(node: Node2D) -> Vector2:
	return node.get_viewport_rect().size
