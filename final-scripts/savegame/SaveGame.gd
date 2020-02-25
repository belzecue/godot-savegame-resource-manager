class_name SaveGame




#On Windows user:// -> C:\Users\yourname\AppData\Roaming\Godot\app_userdata\projectname
#project name can be changed in the project settings
const SAVE_GAME_FOLDER_TEMPLATE : String = "user://savegames"
const SAVE_GAME_NAME_SUFFIX : String = "_%03d.tres"

var SAVE_GAME_TEMPLATE = null

var save_game_profile : String = "default-profile" setget setSaveGameProfile, getSaveGameProfile
var save_game_category : String = "default-category"
var save_game_folder : String = "user://Savegames/default-profile/default-category"
var save_game_name : String = "savegame" + SAVE_GAME_NAME_SUFFIX

var _cur_save_game = null setget ,getCurSaveGame
var _cur_slot : int = 0




func _init(save_game_template, profile_name : String = "", category_name : String = "", save_name : String = "") -> void:
	if profile_name != "":
		save_game_profile = profile_name
	
	if category_name != "":
		save_game_category = category_name
	
	if save_name != "":
		save_game_name = save_name + SAVE_GAME_NAME_SUFFIX
	
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
	return SaveGameLoader.makeDefaultSaveGame(SAVE_GAME_TEMPLATE)


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

func resetSaveGameCategory() -> void:
	save_game_category = "default-category"

func resetSaveGameName() -> void:
	save_game_name = "savegame" + SAVE_GAME_NAME_SUFFIX



func saveGameState(new_save_game, slot : int = 0) -> void:
	_cur_save_game = new_save_game
	_cur_slot = slot
	SaveGameLoader.saveGameState(new_save_game, save_game_folder, save_game_name % slot)


func loadGameState(slot : int = 0) -> void:
	_cur_save_game = SaveGameLoader.loadGameState(SAVE_GAME_TEMPLATE, save_game_folder, save_game_name % slot)
	_cur_slot = slot


func reset() -> void:
	resetSaveGameProfile()
	resetSaveGameCategory()
	pSetSaveGameFolder()
	
	resetSaveGameName()
	resetSaveGame()


func getAbsoluteFilePath(slot : int = 0) -> String:
	return OS.get_user_data_dir().plus_file("savegames").plus_file(save_game_profile).plus_file(save_game_category).plus_file(SAVE_GAME_NAME_SUFFIX % slot)




func pConstructSaveGameFolder() -> String:
	#return SAVE_GAME_FOLDER_TEMPLATE % save_game_profile % save_game_category
	return SAVE_GAME_FOLDER_TEMPLATE.plus_file(save_game_profile).plus_file(save_game_category)

func pSetSaveGameFolder() -> void:
	save_game_folder = pConstructSaveGameFolder()
