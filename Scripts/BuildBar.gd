extends Node2D

@export var TileName :String

var level_up_cost :int = 1000

func _ready() -> void:
	visible = true
	GlobalSignals.connect("electric_change", check_lvl_up)
	GlobalSignals.connect("money_change", check_lvl_up)
	
	
	if TileName == "WEC" or TileName == "SolarPanel":
		$LevelUpButton.text = str(level_up_cost) + " $"
		$ElectricMeasure.text = "+" + str(GlobalSignals.buildings[TileName]["Electric_Production"])
		$LevelUpButton.visible = (GlobalSignals.money >= level_up_cost)
			
	$Button.icon = load("res://Sprites/" + TileName + ".png")
	$Cost.text = str(GlobalSignals.buildings[TileName]["Cost"]) + " $"
	
	
func check_lvl_up() -> void:
	if TileName == "WEC" or TileName == "SolarPanel":
		if $LevelUpButton != null:
			$LevelUpButton.visible = (GlobalSignals.money >= level_up_cost)

	
func _on_button_button_down() -> void:
	GlobalSignals.free_sprite_change.emit(TileName)


func _on_level_up_button_button_down() -> void:
	if TileName == "WEC" or TileName == "SolarPanel":
		if $LevelUpButton != null:
			if GlobalSignals.money >= level_up_cost: 
				$LevelUpButton.visible = true
				GlobalSignals.money -= level_up_cost
				GlobalSignals.money_change.emit()
				level_up_cost += 1000
				$LevelUpButton.text = str(level_up_cost) + " $"
				GlobalSignals.buildings[TileName]["Cost"] *= 1.5
				$Cost.text = str(int(GlobalSignals.buildings[TileName]["Cost"])) + " $"
				
				if TileName == "WEC":
					if GlobalSignals.wec_level < GlobalSignals.electric_productions.size()-1:
						GlobalSignals.wec_level += 1
						GlobalSignals.buildings["WEC"]["Electric_Production"] = GlobalSignals.electric_productions[GlobalSignals.wec_level]
					else:
						$LevelUpButton.visible = false
					
					
				if TileName == "SolarPanel":
					if GlobalSignals.solar_level < GlobalSignals.electric_productions.size()-1:
						GlobalSignals.solar_level += 1
						GlobalSignals.buildings["SolarPanel"]["Electric_Production"] = GlobalSignals.electric_productions[GlobalSignals.solar_level]
					else:
						$LevelUpButton.visible = false
				
				$ElectricMeasure.text = "+" + str(GlobalSignals.buildings[TileName]["Electric_Production"])
			else:
				$LevelUpButton.visible = false
