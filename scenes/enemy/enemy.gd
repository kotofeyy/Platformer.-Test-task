extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_audio_stream_player: AudioStreamPlayer = $HurtAudioStreamPlayer

@export var is_patrolling: bool = false
@export var speed: float = 20.0
var direction: float = -1.0


func _ready() -> void:
	if is_patrolling:
		animated_sprite_2d.play("walk")


func _physics_process(delta: float) -> void:
	if is_patrolling:
		velocity.x = direction * speed
		
		move_and_slide()

		if is_on_wall():
			direction *= -1
			animated_sprite_2d.flip_h = direction > 0


func hit() -> void:
	animated_sprite_2d.play("hit")
	hurt_audio_stream_player.play()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "hit":
		queue_free()


func _on_detected_area_body_entered(body: Node2D) -> void:
	if is_patrolling:
		if body.is_in_group("Player"):
			body.take_damage(10)
