extends Label

# Acessa o main através da árvore de cenas
func _ready():
	# Espera um frame para garantir que a troca de cena foi completada
	await get_tree().process_frame
	
	var main = get_tree().root.get_child(0)  # Pega a cena principal (assumindo que é a primeira)
	if main && main.has_method("get_score"):
		text = str(main.get_score())
	else:
		text = "0"
		printerr("Main scene não encontrada ou método get_score() não existe!")
