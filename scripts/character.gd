extends CharacterBody2D

const GRAVITY: int = 4200
const JUMP_SPEED: int = -1600

@export var knockback_distance := 100
@export var invulnerable_time := 1.5
@export var blink_interval := 0.1

@onready var combustivel_manager = get_parent().get_node("CombustivelManager")

var is_invulnerable := false
var blink_timer := 0.0
var invulnerable_timer := 0.0

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta

	# Agora SIM consome corretamente o combustível
	if combustivel_manager.combustivel > 0:
		combustivel_manager.consumir_combustivel(delta)

	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			jump()
		elif Input.is_action_pressed("ui_down"):
			duck()

	move_and_slide()


func jump() -> void:
	velocity.y = JUMP_SPEED
	# $JumpSound.play()

func duck() -> void:
	$RunningCollision.disabled = true
	# $CharacterAnimation.play("duck")

func _process(delta: float) -> void:
	if is_invulnerable:
		invulnerable_timer -= delta
		blink_timer -= delta
		if blink_timer <= 0:
			$Sprite2D.modulate.a = 1.0 if $Sprite2D.modulate.a < 0.5 else 0.2
			blink_timer = blink_interval
		if invulnerable_timer <= 0:
			$Sprite2D.modulate.a = 1.0
			is_invulnerable = false

func adicionar_combustivel(valor: float) -> void:
	combustivel_manager.adicionar_combustivel(valor)
