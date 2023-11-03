extends Node2D

class_name Grid
var cell_idx :int = 0

const Tile :PackedScene = preload("res://Scenes/Tile.tscn")

@export var width :int = 15
@export var height :int = 10
var cell_size :int = 128
	
	
func SpawnTile(_pos):
	var tile = Tile.instantiate()
	owner.add_child(tile)
	GlobalSignals.all_tiles.append(tile)
	cell_idx += 1
	tile.global_position = _pos
	return tile
	
var dock_spawned :bool = false
var dock_height :int = randi_range(0, int(height/2) - 1)

func GenerateGrid() -> void:
	for i in range(0, width):
		for j in range(0, height):
			var tile = SpawnTile(Vector2(i, j) * cell_size)
			GlobalSignals.grid[tile.name] = {"Pos" : Vector2(i, j), "Type" : null}
			tile.locked = (i <= int(width / 2)) or (j >= int(height / 2))
			
			if i > randi_range(0, int(height/1.5)) and i > randi_range(0, int(width/1.5)):
				if !dock_spawned and i == (width - 1) and (j == dock_height):
					dock_spawned = true
					GlobalSignals.GenerateDock(tile)
					GlobalSignals.right_limit_pos = tile.global_position
					GlobalSignals.grid[tile.name] = {"Pos" : Vector2(i, j), "Type" : "Dock"}
				else:
					tile.ChangeTile("WaterTile")
					GlobalSignals.grid[tile.name] = {"Pos" : Vector2(i, j), "Type" : "WaterTile"}
			else:
				tile.ChangeTile("GroundTile")
				GlobalSignals.grid[tile.name] = {"Pos" : Vector2(i, j), "Type" : "GroundTile"}
