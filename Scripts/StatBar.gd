extends Node2D

@onready var progress_bar :ProgressBar = $ProgressBar
@onready var label :Label = $Label
@export var bar_color :Color

func _ready() -> void:
	visible = true
	Change_Progress_Bar_Color(bar_color)
	
func Change_Progress_Bar(_max_value, _value) -> void:
	progress_bar.max_value = _max_value
	progress_bar.value = _value
	label.text = str(_value)
	

func Change_Progress_Bar_Color(_new_color) -> void:
	var new_theme = StyleBoxFlat.new()
	new_theme.corner_radius_bottom_left = progress_bar.get("theme_override_styles/fill").corner_radius_bottom_left
	new_theme.corner_radius_bottom_right = progress_bar.get("theme_override_styles/fill").corner_radius_bottom_right
	new_theme.corner_radius_top_left = progress_bar.get("theme_override_styles/fill").corner_radius_top_left
	new_theme.corner_radius_top_right = progress_bar.get("theme_override_styles/fill").corner_radius_top_right
	
	new_theme.border_width_bottom = 3
	new_theme.border_width_left = 3
	new_theme.border_width_right = 3
	new_theme.border_width_top = 3
	
	new_theme.bg_color = _new_color
	new_theme.border_color = new_theme.bg_color.darkened(0.7)
	
	progress_bar.set("theme_override_styles/fill", new_theme)
