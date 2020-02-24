class_name SaveGame




#On Windows user:// -> C:\Users\yourname\AppData\Roaming\Godot\app_userdata\projectname
#project name can be changed in the project settings
const SAVE_GAME_FOLDER_TEMPLATE : String = "user://savegames"
const SAVE_GAME_NAME_TEMPLATE : String = "savegame_%03d.tres"

var SAVE_GAME_TEMPLATE = null

var save_game_profile : String = "default-profile" setget setSaveGameProfile, getSaveGameProfile
var save_game_category : String = "default-category"
var save_game_folder : String = "user://Savegames/default-profile/default-category"

var _cur_save_game = null setget ,getCurSaveGame
var _cur_slot : int = 0




func _init(save_game_template, profile_name : String = "", category_name : String = "") -> void:
	if profile_name != "":
		save_game_profile = profile_name
	
	if category_name != "":
		save_game_category = category_name
	
	SAVE_GAME_TEMPLATE = save_game_template
	pSetSaveGameFolder()
	loadGameState(0)



func getCurSaveGame(slot : int = 0):
	if _cur_save_game == null:
		loadGameState(slot)
	else:
		if _cur_slot != slot:
			loadGameState(slot)
	return _cur_save_game

func makeDefaultSaveGame():
	var savegame = SAVE_GAME_TEMPLATE.new()
	
	savegame.setDefaultState()
	
	return savegame

func resetSaveGame(slot : int = 0) -> void:
	saveGameState(makeDefaultSaveGame(), slot)


#should not be used, except it is absolutely necessary 
#if user switches profile a new instance of this class should be created with the
#new profile name 
func setSaveGameProfile(new_profile : String) -> void:
	if new_profile != "":
		save_game_profile = new_profile
		pSetSaveGameFolder()
		loadGameState()

func getSaveGameProfile() -> String:
	return save_game_profile

func resetSaveGameProfile() -> void:
	setSaveGameProfile("default-profile")




func saveGameState(new_save_game, slot : int = 0) -> void:
	new_save_game.game_version = ProjectSettings.get_setting("application/config/version")
	_cur_save_game = new_save_game
	_cur_slot = slot
	var directory : Directory = Directory.new()
	if not directory.dir_exists(save_game_folder):
		directory.make_dir_recursive(save_game_folder)
		
	var save_path = save_game_folder.plus_file(SAVE_GAME_NAME_TEMPLATE % slot)
	var error : int = ResourceSaver.save(save_path, new_save_game)
	if error != OK:
		print("There was an issue writing to %s at slot %s" % [save_path, slot])


func loadGameState(slot : int = 0) -> void:
	var save_file_path : String = save_game_folder.plus_file(SAVE_GAME_NAME_TEMPLATE % slot)
	var file : File = File.new()
	if not file.file_exists(save_file_path):
		print("Save file %s doesn´t exist. New default save game was created." % save_file_path)
		saveGameState(makeDefaultSaveGame(), slot)
	else:
		var save_game = ResourceLoader.load(save_file_path)
		_cur_save_game = save_game
		_cur_slot = slot


func reset() -> void:
	resetSaveGameProfile()
	resetSaveGame()


func getAbsoluteFilePath(slot : int = 0) -> String:
	return OS.get_user_data_dir().plus_file("savegames").plus_file(save_game_profile).plus_file(save_game_category).plus_file(SAVE_GAME_NAME_TEMPLATE % slot)




func pConstructSaveGameFolder() -> String:
	#return SAVE_GAME_FOLDER_TEMPLATE % save_game_profile % save_game_category
	return SAVE_GAME_FOLDER_TEMPLATE.plus_file(save_game_profile).plus_file(save_game_category)

func pSetSaveGameFolder() -> void:
	save_game_folder = pConstructSaveGameFolder()
