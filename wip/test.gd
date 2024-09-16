class_name TestWip extends Node2D

################################################################################
# Description: 
################################################################################

@onready var disk: Sprite2D = $Disk


func _ready() -> void:
	pass
################################################################################
# PROCESSING
################################################################################

# Called as fast as possible, so delta is not constant
func _process(delta: float) -> void:
	pass

# Called in sync with frame rate (1/60th second), so delta should be constant
func _physics_process(delta: float) -> void:
	pass

################################################################################
# INPUT
################################################################################

# Called when there is an input event. The input event propagates up through the
# node tree until a node consumes it: Viewport.set_input_as_handled() .
func _input(event: InputEvent) -> void:
	pass

# Called when an input event hasn't been consumed by _input(). The input event
# propagates up through the node tree until a node consumes it.
func _shortcut_input(event: InputEvent) -> void:
	pass
	
# Called when an input event hasn't been consumed by _input() or any GUI Control
# item. It is called after _shortcut_input() but before _unhandled_input(). The
# input event propagates up through the node tree until a node consumes it.
func _unhandled_key_input(event: InputEvent) -> void:
	pass

# Called when an input event hasn't been consumed by _input() or any GUI Control
# item. It is called after _shortcut_input() and after _unhandled_key_input().
# The input event propagates up through the node tree until a node consumes it.
func _unhandled_input(event: InputEvent) -> void:
	pass

func _notification(what: int) -> void:
	pass

################################################################################
# RENDERING
################################################################################

# Called when CanvasItem has been requested to redraw (after queue_redraw()
func _draw() -> void:
	pass
