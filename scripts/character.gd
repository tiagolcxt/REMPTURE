extends CharacterBody2D

const GRAVITY: int = 4200
const JUMP_SPEED: int = -1600

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += GRAVITY * delta

	if is_on_floor():
		#if not get_parent().game_running:
			#$CharacterAnimation.play("idle")
		#else:
			#$RunningCollision.disabled = false
		if Input.is_action_pressed("ui_up"):
			jump()
		elif Input.is_action_pressed("ui_down"):
			duck()
		
				#$CharacterAnimation.play("run")
		#$CharacterAnimation.play("jump")
	move_and_slide()

func jump():
	velocity.y = JUMP_SPEED
	$JumpSound.play()
	
func duck():
	#$CharacterAnimation.play("duck")
	$RunningCollision.disabled = true
