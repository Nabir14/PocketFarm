extends Spawner2D
class_name RandomSpawner2D

func randomly_spawn_object(object_scenes : Dictionary[PackedScene, float], offset_limit : Vector2) -> Node2D:
	var total : float = 0.0
	
	for object_scene in object_scenes:
		total += object_scenes[object_scene]
	
	var random_number : float = randf_range(0.0, total)
	for object_scene in object_scenes:
		var probability = object_scenes[object_scene]
		
		if random_number < probability:
			var object := object_scene.instantiate()
			
			spawn(
				object,
				Vector2(
					randf_range(-offset_limit.x, offset_limit.x),
					randf_range(-offset_limit.y, offset_limit.y)
				)
			)
		
		random_number -= probability
	
	return null

func remove_object(object : Node2D) -> void:
	spawned_objects.erase(object)
	object.queue_free()
