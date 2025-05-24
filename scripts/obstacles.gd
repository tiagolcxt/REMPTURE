class_name Obstacles

const STUMP_SCENE = preload("res://scenes/stump.tscn")
const ROCK_SCENE = preload("res://scenes/rock.tscn")
const BARREL_SCENE = preload("res://scenes/barrel.tscn")
const BIRD_SCENE = preload("res://scenes/bird.tscn")

var obstacle_types := [STUMP_SCENE, ROCK_SCENE, BARREL_SCENE]
var bird_spawn_heights := [220, 380]
var spawned_obstacles : Array
var last_spawned_obstactle: Object

func get_random_obstacle_type():
	return obstacle_types[randi() % obstacle_types.size()]
	
func get_random_bird_spawn_height():
	return bird_spawn_heights[randi() % bird_spawn_heights.size()]

func remove_obstacle(obstacle):
	obstacle.queue_free()
	spawned_obstacles.erase(obstacle)
	
func clear_all_spawned_obstacles():
	for obstacle in spawned_obstacles:
		obstacle.queue_free()
	spawned_obstacles.clear()
