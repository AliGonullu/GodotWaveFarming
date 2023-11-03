extends Node

signal free_sprite_change(_name)
signal money_change
signal electric_change
signal start_production(tile_name)
signal ui_entered(_value)


var dock_in_range_vectors :Array = []
var path_in_range_vectors :Array = []
var all_tiles :Array
var grid :Dictionary = {}

var night :bool = false
static var money :int = 600
static var electric :int = 0
var right_limit_pos :Vector2

var tile_no :int = 0
var demolish_mode :bool = false

var client_electric_cost_reward :Dictionary = {
	"City A" = {
		"ElectricCost" : 750,
		"Reward" : 300
	},
	"City B" = {
		"ElectricCost" : 1250,
		"Reward" : 500
	},
	"City C" = {
		"ElectricCost" : 1750,
		"Reward" : 800
	},
	"City D" = {
		"ElectricCost" : 2000,
		"Reward" : 1000
	},
	"City E" = {
		"ElectricCost" : 100,
		"Reward" : 50
	},
	"City F" = {
		"ElectricCost" : 500,
		"Reward" : 100
	}
}

var electric_productions :Array = [50, 100, 150, 200, 350, 550, 800, 1000]
var wec_level :int = 0
var solar_level :int = 1

var buildings = {
	"WEC" : {
		"Name" : "WEC",
		"Cost" : 100,
		"TimePerUnit" : 15,
		"Electric_Production" : electric_productions[wec_level]
	},
	"SolarPanel" : {
		"Name" : "SolarPanel",
		"Cost" : 200,
		"TimePerUnit" : 20,
		"Electric_Production" : electric_productions[solar_level]
	},
	"Dock" : {
		"Name" : "Dock",
		"Cost" : 500,
		"TimePerUnit" : 1,
	},
	"Path" : {
		"Name" : "Path",
		"Cost" : 400,
		"TimePerUnit" : 1,
	},
}



func SpendMoney(building_in_hand) -> bool:
	if money >= buildings[building_in_hand]["Cost"]:
		money -= buildings[building_in_hand]["Cost"]
		money_change.emit()
		return true
	return false

func GenerateDock(tile) -> void:
	tile.ChangeTile("Dock")
	DockInRangeVectors(tile.name)

func GeneratePath(tile) -> void:
	tile.ChangeTile("Path")
	PathInRangeVectors(tile.name)

func DockInRangeVectors(_name) -> void:
	var vec1 = Vector2(grid[_name]["Pos"].x + 1, grid[_name]["Pos"].y)
	var vec2 = Vector2(grid[_name]["Pos"].x - 1, grid[_name]["Pos"].y)
	var vec3 = Vector2(grid[_name]["Pos"].x, grid[_name]["Pos"].y + 1)
	var vec4 = Vector2(grid[_name]["Pos"].x, grid[_name]["Pos"].y - 1)
	var vec5 = Vector2(grid[_name]["Pos"].x + 1, grid[_name]["Pos"].y + 1)
	var vec6 = Vector2(grid[_name]["Pos"].x - 1, grid[_name]["Pos"].y - 1)
	var vec7 = Vector2(grid[_name]["Pos"].x + 1, grid[_name]["Pos"].y - 1)
	var vec8 = Vector2(grid[_name]["Pos"].x - 1, grid[_name]["Pos"].y + 1)
	var vec9 = Vector2(grid[_name]["Pos"].x + 2, grid[_name]["Pos"].y)
	var vec10 = Vector2(grid[_name]["Pos"].x - 2, grid[_name]["Pos"].y)
	var vec11 = Vector2(grid[_name]["Pos"].x, grid[_name]["Pos"].y + 2)
	var vec12 = Vector2(grid[_name]["Pos"].x, grid[_name]["Pos"].y - 2)
	
	dock_in_range_vectors.append_array([vec1, vec2, vec3, vec4, vec5, vec6, vec7, vec8, vec9, vec10, vec11, vec12])

func PathInRangeVectors(_name) -> void:
	var vec1 = Vector2(grid[_name]["Pos"].x + 1, grid[_name]["Pos"].y)
	var vec2 = Vector2(grid[_name]["Pos"].x - 1, grid[_name]["Pos"].y)
	var vec3 = Vector2(grid[_name]["Pos"].x, grid[_name]["Pos"].y + 1)
	var vec4 = Vector2(grid[_name]["Pos"].x, grid[_name]["Pos"].y - 1)
	var vec5 = Vector2(grid[_name]["Pos"].x + 1, grid[_name]["Pos"].y + 1)
	var vec6 = Vector2(grid[_name]["Pos"].x - 1, grid[_name]["Pos"].y - 1)
	var vec7 = Vector2(grid[_name]["Pos"].x + 1, grid[_name]["Pos"].y - 1)
	var vec8 = Vector2(grid[_name]["Pos"].x - 1, grid[_name]["Pos"].y + 1)
	var vec9 = Vector2(grid[_name]["Pos"].x + 2, grid[_name]["Pos"].y)
	var vec10 = Vector2(grid[_name]["Pos"].x - 2, grid[_name]["Pos"].y)
	var vec11 = Vector2(grid[_name]["Pos"].x, grid[_name]["Pos"].y + 2)
	var vec12 = Vector2(grid[_name]["Pos"].x, grid[_name]["Pos"].y - 2)
	
	path_in_range_vectors.append_array([vec1, vec2, vec3, vec4, vec5, vec6, vec7, vec8, vec9, vec10, vec11, vec12])
