extends CharacterBody2D

const GRAVITY: int = 4200
const JUMP_SPEED: int = -1600

@export var knockback_distance := 100  # Quanto recua ao colidir
@export var invulnerable_time := 1.5   # Tempo em segundos
@export var blink_interval := 0.1      # Tempo entre piscadas

var is_invulnerable := false
var blink_timer := 0.0
var invulnerable_timer := 0.0

func _physics_process(delta):
	velocity.y += GRAVITY * delta

	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			jump()
		elif Input.is_action_pressed("ui_down"):
			duck()

	move_and_slide()

func jump():
	velocity.y = JUMP_SPEED
	$JumpSound.play()

func duck():
	$RunningCollision.disabled = true
	#$CharacterAnimation.play("duck")  # Descomente se tiver animação

func _process(delta):
	if is_invulnerable:
		invulnerable_timer -= delta
		blink_timer -= delta
		if blink_timer <= 0:
			$Sprite2D.modulate.a = 1.0 if $Sprite2D.modulate.a < 0.5 else 0.2  # Piscar
			blink_timer = blink_interval
		if invulnerable_timer <= 0:
			$Sprite2D.modulate.a = 1.0
			is_invulnerable = false
