extends Node

#-------------------------------------------------------------------------------
#|:::::::::::::::::::::::::::::::::SHOWCASE::::::::::::::::::::::::::::::::::::|
#-------------------------------------------------------------------------------
#const TEST_SAVE_GAME = preload("res://testing/TestSaveGame.gd")
#onready var default_savegame : SaveGame = SaveGame.new(TEST_SAVE_GAME)
#onready var player_savegame_01 : SaveGame = SaveGame.new(TEST_SAVE_GAME, "profile-base", "player")
#onready var player_savegame_02 : SaveGame = SaveGame.new(TEST_SAVE_GAME, "profile-advanced", "player")
#onready var world_savegame_01 : SaveGame = SaveGame.new(TEST_SAVE_GAME, "profile-base", "world")
#onready var world_savegame_02 : SaveGame = SaveGame.new(TEST_SAVE_GAME, "profile-advanced", "world")
#
#
#
#func _ready() -> void:
#	#simple test showcase
#	print(player_savegame_01.getAbsoluteFilePath(0))
#	print(player_savegame_02.getAbsoluteFilePath(0))
#	print(world_savegame_01.getAbsoluteFilePath(0))
#	print(world_savegame_02.getAbsoluteFilePath(0))
#
#	var sg : TestSaveGame = player_savegame_01.getCurSaveGame(0)
#	sg.player_name = "DOODLE"
#	sg.last_health_points = 5
#	sg.last_position = Vector2(13, 25)
#	player_savegame_01.saveGameState(sg, 0)
#	player_savegame_01.saveGameState(sg, 3)
#
#	sg = player_savegame_01.getCurSaveGame(2)
#	sg.player_name = "John"
#	player_savegame_01.saveGameState(sg, 2)
#
#	print("Slot 0: " + player_savegame_01.getCurSaveGame(0).player_name)
#	print("Slot 1: " + player_savegame_01.getCurSaveGame(1).player_name)
#	print("Slot 2: " + player_savegame_01.getCurSaveGame(2).player_name)
#	print("Slot 3: " + player_savegame_01.getCurSaveGame(3).player_name)
#
#	player_savegame_02.saveGameState(sg, 0)
#	print("Slot 0: " + player_savegame_02.getCurSaveGame(0).player_name)
#-------------------------------------------------------------------------------
#|:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::|
#-------------------------------------------------------------------------------
