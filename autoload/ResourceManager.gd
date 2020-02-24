extends Node



#----------------------SHOWCASE-------------------------------------------------
#func _ready() -> void:
#	print("-------------------LOAD SINGLE RESOURCE-------------------")
#	var resource : Resource = loadResourceFrom("res://test-resources/a/Curve_Test_01.tres")
#	print("Resource1: " + str(resource))
#	print("----------------------------------------------------------")
#
#	print("------------LOAD ALL RESOURCES FROM A DIRECTORY-----------")
#	var resources : Array = loadAllResourcesFrom("res://test-resources/a/Curve_Test_01.tres")
#	for r in resources:
#		print("Resource Array: " + str(r))
#	print("----------------------------------------------------------")
#
#	print("----------LOAD ALL SUB RESOURCES FROM A DIRECTORY---------")
#	var resources_hierarchy : Array = loadAllSubResourcesFrom("res://test-resources")
#	for r in resources_hierarchy:
#		print("Resource Array: " + str(r))
#	print("----------------------------------------------------------")
#-------------------------------------------------------------------------------



func loadResourceFrom(file_path : String) -> Resource:
	var r : Resource = null
	print("file: "+ str(file_path.get_file()))
	if ResourceLoader.exists(file_path):
		r = ResourceLoader.load(file_path)
	else:
		push_warning("Resource at %s does not exist. Return value is null." % file_path)
		print("Resource at %s does not exist. Return value is null." % file_path)
	return r


func loadAllSubResourcesFrom(directory_path : String) -> Array:
	var dir : Directory = Directory.new()
	directory_path = pCheckDirectoryPath(directory_path, dir)
	if directory_path == "": return []
		
	var resources : Array = []
	if dir.open(directory_path) == OK:
		dir.list_dir_begin(true, false)
		var file_name : String = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				var file : String = directory_path.plus_file(file_name)
				if ResourceLoader.exists(file):
					resources.append(ResourceLoader.load(file))
			else:
				var directory : String = directory_path.plus_file(file_name)
				resources += loadAllSubResourcesFrom(directory)
			file_name = dir.get_next()
	else:
		push_warning("Resources could not be loaded from %s. Did you mean %s ?" %[directory_path, directory_path.get_base_dir()])
		print("Resources could not be loaded from %s. Did you mean %s ?" % [directory_path, directory_path.get_base_dir()])
	
	dir.list_dir_end()
	return resources


func loadAllResourcesFrom(directory_path : String) -> Array:
	var dir : Directory = Directory.new()
	directory_path = pCheckDirectoryPath(directory_path, dir)
	if directory_path == "": return []
		
	var resources : Array = []
	if dir.open(directory_path) == OK:
		dir.list_dir_begin()
		var file_name : String = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				var file = directory_path.plus_file(file_name)
				if ResourceLoader.exists(file):
					resources.append(ResourceLoader.load(file))
			file_name = dir.get_next()
	else:
		push_warning("Resources could not be loaded from %s. Did you mean %s ?" %[directory_path, directory_path.get_base_dir()])
		print("Resources could not be loaded from %s. Did you mean %s ?" % [directory_path, directory_path.get_base_dir()])
	
	dir.list_dir_end()
	return resources




func pCheckDirectoryPath(path : String, dir : Directory) -> String:
	var return_path : String = ""
	if path.get_extension() != "":
		var old_directory : String = path
		var extension : String = path.get_extension()
		var new_directory : String = path.get_base_dir()
		
		if dir.dir_exists(new_directory):
			push_warning("Path %s included file extension %s. Function needs a directory path!" %[old_directory, extension])
			print("Path %s included file extension %s. Function needs a directory path!" %[old_directory, extension])
			return_path = new_directory
			push_warning("Path changed to %s." % new_directory)
			print("Path changed to %s." % new_directory)
		else:
			push_warning("Path %s included file extension %s. Function needs a directory path!" %[old_directory, extension])
			print("Path %s included file extension %s. Function needs a directory path!" %[old_directory, extension])
			push_warning("Resources could not be loaded from %s." %path)
			print("Resources could not be loaded from %s." % path)
	else:
		if dir.dir_exists(path):
			return_path = path
	
	return return_path
























#func dir_contents(path):
#    var dir = Directory.new()
#    if dir.open(path) == OK:
#        dir.list_dir_begin()
#        var file_name = dir.get_next()
#        while file_name != "":
#            if dir.current_is_dir():
#                print("Found directory: " + file_name)
#            else:
#                print("Found file: " + file_name)
#            file_name = dir.get_next()
#    else:
#        print("An error occurred when trying to access the path.")

#func loadAllResourcesFromDirectory(path : String, template : String) -> Array:
#	var save_path : String = ""
#	var file : File = File.new()
#	var resources : Array = []
#	var index : int = 0
#	while true:
#		save_path = path.plus_file(template % index)
#		if file.file_exists(save_path):
#			var l = ResourceLoader.load(save_path)
#			resources.append(l)
#		else:
#			break
#		index += 1
#	return resources
