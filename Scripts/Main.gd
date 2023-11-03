extends Node2D

var active_scene :String = "Production"

@onready var grid = $ProductionBase/Grid
@onready var electric_bar = $CanvasLayer/ElecrtricBar
@onready var money_bar = $CanvasLayer/MoneyBar
@onready var free_sprite = $ProductionBase/FreeSprite

static var curr_grid
static var max_electric :int = 1000
static var max_money :int = 1000

func _ready() -> void:
	visible = true
	$CanvasLayer.visible = true
	$ProductionBase/CanvasLayer.visible = true
	$DirectionalLight2D.energy = 0.0
	GlobalSignals.connect("electric_change", electric_changed)
	GlobalSignals.connect("money_change", money_changed)
	GlobalSignals.connect("free_sprite_change", free_sprite_changed)
	
	electric_bar.Change_Progress_Bar(max_electric, GlobalSignals.electric)
	money_bar.Change_Progress_Bar(max_money, GlobalSignals.money)
	grid.GenerateGrid()



func money_changed() -> void:
	if max_money < GlobalSignals.money:
		max_money *= 2
	money_bar.Change_Progress_Bar(max_money, GlobalSignals.money)


func electric_changed() -> void:
	if max_electric < GlobalSignals.electric:
		max_electric *= 2
	electric_bar.Change_Progress_Bar(max_electric, GlobalSignals.electric)



func free_sprite_changed(_name) -> void:
	if _name != "":
		if _name == "WEC":
			free_sprite.texture = load("res://Sprites/" + _name + "NotPlaced" + ".png")
		else:
			free_sprite.texture = load("res://Sprites/" + _name + ".png")
	else:
		free_sprite.texture = null
	

var forward_day :bool = true
var day_speed :float = 0.1

func _process(delta) -> void:
	if $DirectionalLight2D.energy > 0.89:
		forward_day = false
	if $DirectionalLight2D.energy < 0.0:
		forward_day = true
	if $DirectionalLight2D.energy < 0.49:
		GlobalSignals.night = false
	else:
		GlobalSignals.night = true
	
	if forward_day:
		$DirectionalLight2D.energy += clamp(day_speed * delta * delta, 0, 10)
	else:
		$DirectionalLight2D.energy -= clamp(day_speed * delta * delta, 0, 10)
	
	if active_scene == "Production":
		$ProductionBase.visible = true
		$WorldMap.visible = false
	elif active_scene == "WorldMap":
		$ProductionBase.visible = false
		$WorldMap.visible = true
	
	if free_sprite.texture != null:
		free_sprite.global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("right_click"):
		GlobalSignals.free_sprite_change.emit("")
		GlobalSignals.demolish_mode = false
		

func _on_production_base_visibility_changed() -> void:
	$ProductionBase/CanvasLayer.visible = $ProductionBase.visible

func _on_change_scene_button_down() -> void:
	if active_scene == "WorldMap":
		active_scene = "Production"
	elif active_scene == "Production":
		active_scene = "WorldMap"


func _on_claim_all_button_down() -> void:
	for i in GlobalSignals.all_tiles:
		i.Claim_Electricity()


func _on_demolish_button_down() -> void:
	GlobalSignals.demolish_mode = !GlobalSignals.demolish_mode


var GoldPile :PackedScene = load("res://Scenes/GoldPile.tscn")
func _on_gold_pile_timer_timeout() -> void:
	var water_tiles :Array
	for i in GlobalSignals.all_tiles:
		if i.active_tile == "WaterTile" and i.locked == false and i.production.curr_building == "":
			water_tiles.append(i)
			
	var gold_pile = GoldPile.instantiate()
	get_tree().current_scene.add_child(gold_pile)
	gold_pile.global_position = water_tiles[randi_range(0, water_tiles.size()-1)].global_position
	$GoldPileTimer.start(randi_range(5, 10))


func _on_area_2d_mouse_entered() -> void:
	GlobalSignals.ui_entered.emit(true)


func _on_area_2d_mouse_exited() -> void:
	GlobalSignals.ui_entered.emit(false)
