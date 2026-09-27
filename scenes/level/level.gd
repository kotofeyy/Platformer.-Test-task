extends Node2D
@onready var cpu_particles_2d: CPUParticles2D = $CanvasLayer/CPUParticles2D
@onready var cpu_particles_2d_2: CPUParticles2D = $CanvasLayer/CPUParticles2D2


func _on_limit_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(10)
		body.global_position = Vector2(36, -1)


func _on_finish_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		cpu_particles_2d.emitting = true
		cpu_particles_2d_2.emitting = true
		print("конец игры")
