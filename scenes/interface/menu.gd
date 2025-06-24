extends Control

func _ready():
	# Garante que a música está tocando (se não estiver)
	pass

func _on_jogar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_controles_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/interface/controles.tscn")

func _on_sobre_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/interface/Sobre.tscn")

func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/interface/menu_2.tscn")

func _on_sair_pressed() -> void:
	get_tree().quit()

func _on_não_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/interface/menu.tscn")
