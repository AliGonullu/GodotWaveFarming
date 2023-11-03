extends Node2D

var tile_matches :Dictionary = {
	"GroundTile" : ["SolarPanel", "Path"],
	"WaterTile" : ["WEC", "Dock"],
	"Dock" : ["None", "None"],
	"Path" : ["None", "None"]
}

var active_tile
var first_tile
var locked :bool = false
var mouse_entered :bool = false
var building_in_hand :String = ""
var can_afford :bool = false
var unlock_price :int = 100
@onready var unlock_price_text :Label = $UnlockPrice
@onready var production = $Production
var broken = false
var number_of_uses :int = 10
var fix_cost :int = 50

func _ready() -> void:
	visible = true
	unlock_price_text.text = str(unlock_price) + " $"
	name = "Tile" + str(GlobalSignals.tile_no)
	GlobalSignals.tile_no += 1
	GlobalSignals.start_production.emit(name)
	GlobalSignals.connect("free_sprite_change", free_sprite_changed)
	GlobalSignals.connect("ui_entered", ui_entered)
	$ColorRect.visible = false
	$UnlockPrice.visible = false
	$FixPrice.text = str(fix_cost) + " $"
	
var ui_enter :bool = false
func ui_entered(_value) -> void:
	ui_enter = _value
	
func ChangeTile(_name) -> void:
	active_tile = _name
	first_tile = active_tile
	$Sprite2D.texture = load("res://Sprites/" + active_tile + ".png")
	if locked:
		$Sprite2D.modulate = Color.DIM_GRAY
	
	
func _process(_delta) -> void:
	$FixPrice.visible = broken
	$Production.visible = !broken
	if GlobalSignals.night and production.curr_building != "":
		$Light.visible = true
		$Light.color = Color.RED if broken else Color.WHITE
	else:
		$Light.visible = false
		
		
	if ui_enter:
		mouse_entered = false
	$ColorRect.visible = mouse_entered
	if locked:
		unlock_price_text.visible = mouse_entered
	if mouse_entered:
		if Input.is_action_just_pressed("left_click"):
			if !locked:
				if GlobalSignals.demolish_mode:
					$OccupyingBuild.texture = null
					$Production.curr_building = ""
					active_tile = first_tile
					$Production.close_production()
					
				elif broken:
					if GlobalSignals.money >= fix_cost:
						GlobalSignals.money -= fix_cost
						fix_cost += 50
						$FixPrice.text = str(fix_cost) + " $"
						GlobalSignals.money_change.emit()
						number_of_uses = 10
						broken = false
						production.close_production()
						GlobalSignals.start_production.emit(name)
				else:
					if $ColorRect.color == Color.GREEN:
						if building_in_hand != "":
							can_afford = GlobalSignals.SpendMoney(building_in_hand)
							
							if can_afford:
								$OccupyingBuild.texture = load("res://Sprites/" + building_in_hand + ".png")
								$Production.curr_building = building_in_hand
								GlobalSignals.grid[name] = {"Pos" : GlobalSignals.grid[name]["Pos"], "Type" : building_in_hand}
								
								if building_in_hand == "Dock":
									GlobalSignals.DockInRangeVectors(name)
									$Production.maintain_electric = false
								
								if building_in_hand == "Path":
									GlobalSignals.PathInRangeVectors(name)
									$Production.maintain_electric = false
								GlobalSignals.start_production.emit(name)
							GlobalSignals.free_sprite_change.emit("")
					Claim_Electricity()
			else:
				if GlobalSignals.money >= unlock_price:
					GlobalSignals.money -= unlock_price
					GlobalSignals.money_change.emit()
					locked = false
					$Sprite2D.modulate = Color.WHITE
					unlock_price_text.queue_free()
					$UnlockPrice.queue_free()


func Claim_Electricity() -> void:
	if $Production.ready_for_claim and !broken:
		$Production.Claim()
	

func free_sprite_changed(_name) -> void:
	building_in_hand = _name
	if building_in_hand != "":
		can_afford = (GlobalSignals.money >= GlobalSignals.buildings[building_in_hand]["Cost"])


func _on_area_2d_mouse_entered() -> void:
	z_index = 10
	mouse_entered = true
	if GlobalSignals.demolish_mode:
		$ColorRect.color = Color.RED
	elif locked:
		$Sprite2D.modulate = Color.DIM_GRAY
	else:
		if building_in_hand != "":
			if can_afford and tile_matches[active_tile].has(building_in_hand) and (GlobalSignals.dock_in_range_vectors.has(GlobalSignals.grid[name]["Pos"]) or GlobalSignals.path_in_range_vectors.has(GlobalSignals.grid[name]["Pos"])) and $OccupyingBuild.texture == null:
				$ColorRect.color = Color.GREEN
			else:
				$ColorRect.color = Color.RED
		else:
			$ColorRect.color = "ffaf76"

	
	
func _on_area_2d_mouse_exited() -> void:
	z_index = 0
	mouse_entered = false


func _on_visible_on_screen_notifier_2d_screen_entered():
	$Sprite2D.visible = true
	$ColorRect.visible = true
	$OccupyingBuild.visible = true
	$FixPrice.visible = true
	$Light.visible = true
	

func _on_visible_on_screen_notifier_2d_screen_exited():
	$Sprite2D.visible = false
	$ColorRect.visible = false
	$OccupyingBuild.visible = false
	$FixPrice.visible = false
	$Light.visible = false
