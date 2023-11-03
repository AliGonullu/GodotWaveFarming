extends Node2D


func _ready():
	visible = true

func _on_button_button_down() -> void:
	GlobalSignals.money += randi_range(5, 50)
	GlobalSignals.money_change.emit()
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()

func _on_move_timeout() -> void:
	global_position.x += 128
	if global_position.x > GlobalSignals.right_limit_pos.x:
		$Move.queue_free()
		$Timer.queue_free()
		queue_free()
	$Move.start(0.9)
