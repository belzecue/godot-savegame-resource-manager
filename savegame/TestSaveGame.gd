extends Resource

class_name TestSaveGame

#is filled in automatically with each save from the project settings 
#at project settings -> application -> config add a version property
#Category -> application/config || Property -> version
var game_version = ""


export(int) var last_health_points = 0
export(Vector2) var last_position = Vector2.ZERO
export(String) var player_name = "Player"
export(float) var speed_percentage = 0.5

#sets all members to default
#must be implemented or usage must be removed from SaveGame class
func setDefaultState() -> void:
	game_version = "0.0.00"
	last_health_points = 0
	last_position = Vector2.ZERO
	player_name = "Player"
	speed_percentage = 0.5
