extends Resource

class_name TestSaveGame


var game_version = ""


export(int) var last_health_points = 0
export(Vector2) var last_position = Vector2.ZERO
export(String) var player_name = "Player"
export(float) var speed_percentage = 0.5


func setDefaultState() -> void:
	last_health_points = 0
	last_position = Vector2.ZERO
	player_name = "Player"
	speed_percentage = 0.5
