extends Node2D

func _ready():
	visible = true
	$CanvasLayer.visible = true

func _on_visibility_changed() -> void:
	$CanvasLayer.visible = visible
