extends Label

func _ready():
	# Espera um frame para garantir que a troca de cena foi completada
	await get_tree().process_frame
	
	var main = get_tree().root.get_child(0)  # Pega a cena principal
	if main && main.has_method("get_high_score"):
		text = str(main.get_high_score())
	else:
		text = "0"
		printerr("Main scene não encontrada ou método get_high_score() não existe!")
