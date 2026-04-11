extends Node
class_name WindowsManager

@export var windows_child_parent : Node
@export var windows_child_temp_parent : Node2D

func append_new_window(callback : Callable, window_child : Node = null):
	var window = Window.new()
	window.always_on_top = true
	window.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_PRIMARY_SCREEN
	window.unresizable = true
	window.size = Vector2i(640, 480)
	window.close_requested.connect(close_window.bind(window, callback))
	
	var children = windows_child_temp_parent.get_children()
	for child in children:
		child.reparent(window)
	
	if window_child:
		window.add_child(window_child)
	
	windows_child_parent.add_child(window)

func close_window(window : Window, callback : Callable) -> void:
	var children = window.get_children()

	for child in children:
		child.reparent(windows_child_temp_parent)
	
	window.queue_free()
	callback.call()
