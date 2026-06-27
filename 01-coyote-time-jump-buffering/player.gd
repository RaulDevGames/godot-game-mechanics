extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var coyote_time := 0.15
var coyote_timer := 0.0

@export var jump_buffer_time := 0.15
var jump_buffer_timer := 0.0

func _physics_process(delta: float) -> void:
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = jump_buffer_time
	
	jump_buffer_timer -= delta
	
	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0
		coyote_timer = 0
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
