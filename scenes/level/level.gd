extends Node2D
@onready var cpu_particles_2d: CPUParticles2D = $CanvasLayer/CPUParticles2D
@onready var cpu_particles_2d_2: CPUParticles2D = $CanvasLayer/CPUParticles2D2
@onready var win_panel: Panel = $CanvasLayer/WinPanel
@onready var timer_label: Label = $CanvasLayer/WinPanel/TimerLabel
@onready var win_audio_stream_player: AudioStreamPlayer = $WinAudioStreamPlayer
@onready var pause_label: Label = $CanvasLayer/MarginContainer/PauseLabel

var level_start_time: int


func _ready() -> void:
	level_start_time = Time.get_ticks_msec()


func _on_limit_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(10)
		body.global_position = Vector2(36, -1)


func _on_finish_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		finish_level()


func show_win_panel() -> void:
	win_panel.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(win_panel, "scale", Vector2(1.0, 1.0), 0.2).from(Vector2(0.3, 0.3))


func finish_level() -> void:
	cpu_particles_2d.emitting = true
	cpu_particles_2d_2.emitting = true
	win_audio_stream_player.play()
	show_win_panel()

	var elapsed_msec = Time.get_ticks_msec() - level_start_time
	var elapsed_seconds = elapsed_msec / 1000.0
	timer_label.text = "Время прохождения: " + str(elapsed_seconds) + " секунд"


func _on_close_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainmenu/main_menu.tscn")
