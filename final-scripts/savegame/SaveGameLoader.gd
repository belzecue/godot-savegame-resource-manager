class_name SaveGameLoader


#-------------------IMPORTANT---------------------------------------------------
#SAVE GAME TEMPLATES (RESOURCE SCRIPTS) should implement the following 2 things:
#var game_version = "" -> project settings field - Category: application/config || Property: version
#func setDefaultState() -> void: -> is used to set all members to their default value
#you can disable this behavior by commenting the first line of code in saveGameState
#and the second line of code in makeDefaultSaveGame
#-------------------------------------------------------------------------------


static func saveGameState(new_save_game, directory_path : String, file_name : String) -> void:
	#you can change "application/config/version" to some other path if you want
	#to have the game version somewhere else
	#comment out the next line if you dont want to use the game version field
	new_save_game.game_version = ProjectSettings.get_setting("application/config/version")
	
	var directory : Directory = Directory.new()
	if not directory.dir_exists(directory_path):
		directory.make_dir_recursive(directory_path)
		
	var save_path = directory_path.plus_file(file_name)
	var error : int = ResourceSaver.save(save_path, new_save_game)
	if error != OK:
		print("There was an issue writing to %s." %save_path)


static func loadGameState(save_game_template, directory_path : String, file_name : String):
	var save_file_path : String = directory_path.plus_file(file_name)
	var file : File = File.new()
	if not file.file_exists(save_file_path):
		print("Save file %s doesn´t exist. New default save game was created." % save_file_path)
		var default_save_game = makeDefaultSaveGame(save_game_template)
		saveGameState(default_save_game, directory_path, file_name)
		return default_save_game
	else:
		var save_game = ResourceLoader.load(save_file_path)
		return save_game


static func makeDefaultSaveGame(save_game_template):
	var savegame = save_game_template.new()
	#comment out the next line if you dont want to use the set default state function
	savegame.setDefaultState()
	return savegame
