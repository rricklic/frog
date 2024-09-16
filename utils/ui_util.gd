class_name UIUtil extends Node

################################################################################
# Set the pivot_offset to the center of the control node.
# Useful when modifying the scale of UI elements (e.g.: on hover)
################################################################################
static func center_pivot_offset(control_node: Control) -> void:
	control_node.pivot_offset = control_node.size / 2.0
