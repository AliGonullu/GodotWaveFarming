extends Node2D

var maintain_electric :bool = true
var curr_building :String = ""
var ready_for_claim :bool = false

var enabled_production = false

func _ready() -> void:
	visible = true
	if enabled_production:
		if curr_building == "SolarPanel":
			if !GlobalSignals.night:
				production_started(get_parent().name)
		else:
			production_started(get_parent().name)
	close_production()
	GlobalSignals.connect("start_production", production_started)
	

func production_started(_tile_name) -> void:
	if curr_building != "" and _tile_name == get_parent().name:
		enabled_production = true
		$StatBar.visible = true
		$AnimationPlayer.play("Fill")


func Produce() -> void:
	if maintain_electric:
		if curr_building == "WEC":
			if !GlobalSignals.night:
				GlobalSignals.electric += GlobalSignals.buildings[curr_building]["Electric_Production"]
			else:
				GlobalSignals.electric += 2 * GlobalSignals.buildings[curr_building]["Electric_Production"]
		if curr_building == "SolarPanel":
			if !GlobalSignals.night:
				GlobalSignals.electric += GlobalSignals.buildings[curr_building]["Electric_Production"]
			else:
				enabled_production = false
		
		GlobalSignals.electric_change.emit()


func production_began() -> void:
	$AnimationPlayer.speed_scale /= GlobalSignals.buildings[curr_building]["TimePerUnit"] 


func fill_anim_end() -> void:
	if maintain_electric:
		$StatBar.Change_Progress_Bar_Color("27ffe2") 
		$ElectricIcons.visible = true
		$AnimationPlayer.play("FloatingElectricity")
		ready_for_claim = true
	else:
		$StatBar/ProgressBar.visible = false
		$ElectricIcons.visible = false
			
			
func Claim() -> void:
	if !get_parent().broken:
		get_parent().number_of_uses -= 1
		if get_parent().number_of_uses <= 0:
			get_parent().broken = true
		$AnimationPlayer.speed_scale = 1
		ready_for_claim = false
		Produce()
		$ElectricIcons.visible = false
		$StatBar/ProgressBar.value = 0
		$CoolDown.start()
		$StatBar.Change_Progress_Bar_Color("00ff28")


func _on_cool_down_timeout() -> void:
	close_production()
	if enabled_production:
		$AnimationPlayer.speed_scale = 1
		if curr_building == "SolarPanel":
			if !GlobalSignals.night:
				production_started(get_parent().name)
		else:
			production_started(get_parent().name)
	
func close_production() -> void:
	$StatBar.Change_Progress_Bar_Color("00ff28")
	ready_for_claim = false
	$StatBar/ProgressBar.value = 0
	$ElectricIcons.visible = false
	$StatBar.visible = false
	$AnimationPlayer.stop()
	$AnimationPlayer.speed_scale = 1
