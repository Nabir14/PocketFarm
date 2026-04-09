extends Node2D
class_name Spawner2D

signal spawned

var spawned_objects : Array[Node2D]

func spawn(object : Node2D, object_position : Vector2) -> void:
	object.global_position = object_position
	spawned_objects.append(object)
	self.call_deferred("add_child", object)
	
	spawned.emit()

func is_object_present_at(object_position : Vector2) -> bool:
	for object in spawned_objects:
		if object.global_position == object_position:
			return true
	return false
