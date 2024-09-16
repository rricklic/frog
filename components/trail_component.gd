class_name TrailComponent extends Line2D

# NOTE: parent must have global_position

@export var max_num_points: int = 8

func clear() -> void:
	clear_points()

func _physics_process(delta: float) -> void:
	add_point(get_parent().global_position) 
	if (get_point_count() > max_num_points):
		remove_point(0)
