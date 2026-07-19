extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const WALL_SLIDE_SPEED = 100.0
const WALL_JUMP_FORCE = Vector2(300.0, -400.0)
const WALL_JUMP_TIME = 0.15

var wall_jump_lock = 0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if wall_jump_lock > 0:
		wall_jump_lock -= delta
		move_and_slide()
		return
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var wall_direction = get_wall_normal().x
	var wall_slide = is_on_wall() and !is_on_floor() and velocity.y > 0 and direction == -wall_direction
	
	if wall_slide:
		velocity.y = min(velocity.y, WALL_SLIDE_SPEED)
	
	if wall_slide and Input.is_action_just_pressed("jump"):
		velocity.x = wall_direction * WALL_JUMP_FORCE.x
		velocity.y = WALL_JUMP_FORCE.y
		wall_jump_lock = WALL_JUMP_TIME
	
	move_and_slide()
