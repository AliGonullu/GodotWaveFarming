extends Node2D

var possible_names :Array = ["City A", "City B", "City C", "City D", "City E", "City F"]


static var name_idx :int = 0
var timeout_time :int = 10

var client_name :String
var electric_cost :int
var reward :int

func _ready() -> void:
	visible = true
	client_name = possible_names[name_idx]
	name_idx += 1
	name_idx %= possible_names.size()
	electric_cost = GlobalSignals.client_electric_cost_reward[client_name]["ElectricCost"]
	reward = GlobalSignals.client_electric_cost_reward[client_name]["Reward"]
	$ClientName.text = client_name
	$ElectricCost.text = "Cost : " + str(electric_cost)
	$Reward.text = "Reward : " + str(reward) + " $"
	

func _on_button_button_down() -> void:
	if electric_cost <= GlobalSignals.electric:
		GlobalSignals.electric -= electric_cost
		GlobalSignals.money += reward
		GlobalSignals.electric_change.emit()
		GlobalSignals.money_change.emit()
		electric_cost = 0
		reward = 0
		$ElectricCost.text = "Cost : " + str(electric_cost)
		$Reward.text = "Reward : " + str(reward) + " $"
		$Button.disabled = true
		$Timeout.start(timeout_time)
		
		
func _on_timeout_timeout() -> void:
	$Button.disabled = false
	electric_cost = GlobalSignals.client_electric_cost_reward[client_name]["ElectricCost"]
	reward = GlobalSignals.client_electric_cost_reward[client_name]["Reward"]
	var _change = randi_range(int(electric_cost / 4), electric_cost)
	electric_cost += int(_change * 3)
	reward += int(_change / 2)
	$ElectricCost.text = "Cost : " + str(electric_cost)
	$Reward.text = "Reward : " + str(reward) + " $"
	
