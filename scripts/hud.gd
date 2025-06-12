class_name Hud

var GLOBALS = Globals.new()
var hud_instance

func _init(hud_instance):
	self.hud_instance = hud_instance

func hide_start_hud():
	hud_instance.get_node("StartLabel").hide()
	hud_instance.get_node("ArrowUp").hide()
	hud_instance.get_node("ArrowDown").hide()

func show_start_hud():
	hud_instance.get_node("StartLabel").show()
	hud_instance.get_node("ArrowUp").show()
	hud_instance.get_node("ArrowDown").show()

func show_score(score):
	hud_instance.get_node("ScoreLabel").text = "SCORE: " + str(score / GLOBALS.SCORE_MODIFIER)

func show_high_score(high_score):
	hud_instance.get_node("HighScoreLabel").text = "HIGH SCORE: " + str(high_score / GLOBALS.SCORE_MODIFIER)

func show_combustivel(valor):
	hud_instance.get_node("CombustivelLabel").text = "COMBUSTÍVEL: " + str(round(valor))
