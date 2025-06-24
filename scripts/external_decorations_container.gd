class_name ExternalDecorationsContainer
extends Node2D

# Cenas de decoração mapeadas por tipo (string)
const DECORATION_SCENES := {
	"raio": preload("res://scenes/raio.tscn"),
}

@export var spawn_chance: float = 1.0  # 100% de chance pois queremos controle manual
@export var min_scale: float = 1.0    # Sem aleatorização de escala
@export var max_scale: float = 1.0

var spawned_decorations: Array = []

func spawn_decorations_at_markers():
	clear_all_decorations()
	
	for marker in get_children():
		if not marker is Marker2D:
			continue
			
		var decoration_type = marker.get_meta("String", "quadro")
		var decoration_scene = DECORATION_SCENES.get(decoration_type)
		
		if decoration_scene:
			var decoration = decoration_scene.instantiate()
			decoration.position = marker.position
			decoration.z_index = marker.get_meta("Index_z", 0)
			
			# Sem aleatorização pois queremos posicionamento exato
			get_parent().add_child(decoration)
			spawned_decorations.append(decoration)

func remove_decoration(decoration: Node2D):
	if is_instance_valid(decoration):
		decoration.queue_free()
	spawned_decorations.erase(decoration)

func clear_all_decorations():
	for decoration in spawned_decorations:
		if is_instance_valid(decoration):
			decoration.queue_free()
	spawned_decorations.clear()

func update_decorations(camera_position: Vector2, screen_size: Vector2):
	for decoration in spawned_decorations.duplicate():
		var global_pos = get_parent().to_global(decoration.position)
		if global_pos.x < (camera_position.x - screen_size.x * 1.5):
			remove_decoration(decoration)
