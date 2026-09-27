extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea
@onready var hp_bar: ProgressBar = $"../CanvasLayer/MarginContainer/HPBar"

@export var gravity: float = 1000.0
@export var speed: float = 300.0
@export var jump_velocity: float = -300.0
var HP: float = 100:
	set(new_value):
		HP = new_value
		hp_bar.value = HP


enum State {
	IDLE,
	RUN,
	JUMP,
	FALL,
	ATTACK
}

var state := State.IDLE


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction := Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction * speed
		attack_area.scale.x = abs(attack_area.scale.x) * sign(direction)
		animated_sprite_2d.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		change_state(State.JUMP)

	if Input.is_action_just_pressed("attack") and is_on_floor():
		change_state(State.ATTACK)
		attack_area.monitoring = true

	move_and_slide()

	update_state(direction)


func change_state(new_state: State):
	if state == new_state:
		return

	state = new_state

	match state:
		State.IDLE:
			animated_sprite_2d.play("idle")

		State.RUN:
			animated_sprite_2d.play("run")

		State.JUMP:
			animated_sprite_2d.play("jump")

		State.ATTACK:
			animated_sprite_2d.play("attack")


func update_state(direction: float):
	match state:
		State.ATTACK:
			pass

		State.JUMP:
			if velocity.y > 0:
				change_state(State.FALL)

		State.FALL:
			if is_on_floor():
				if direction:
					change_state(State.RUN)
				else:
					change_state(State.IDLE)

		State.IDLE:
			if not is_on_floor():
				change_state(State.FALL)
			elif direction:
				change_state(State.RUN)

		State.RUN:
			if not is_on_floor():
				change_state(State.FALL)
			elif not direction:
				change_state(State.IDLE)


func _on_animated_sprite_2d_animation_finished() -> void:
	if state == State.ATTACK:
		attack_area.monitoring = false
		if Input.get_axis("move_left", "move_right"):
			change_state(State.RUN)
		else:
			change_state(State.IDLE)


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.hit()


func take_damage(damage: int) -> void:
	HP = clamp(HP - damage, 0, 100)


func take_health_points(value: int) -> void:
	HP = clamp(HP + value, 0, 100)
