class_name DirectoryLoader




static func loadFrom(file_path : String) -> Resource:
	var r : Resource = null
	print("file: "+ str(file_path.get_file()))
	if ResourceLoader.exists(file_path):
		r = ResourceLoader.load(file_path)
	else:
		push_warning("Resource at %s does not exist. Return value is null." % file_path)
		print("Resource at %s does not exist. Return value is null." % file_path)
	return r


static func loadAllDeepFrom(directory_path : String) -> Array:
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
				resources += loadAllDeepFrom(directory)
			file_name = dir.get_next()
	else:
		push_warning("Resources could not be loaded from %s. Did you mean %s ?" %[directory_path, directory_path.get_base_dir()])
		print("Resources could not be loaded from %s. Did you mean %s ?" % [directory_path, directory_path.get_base_dir()])
	
	dir.list_dir_end()
	return resources


static func loadAllFrom(directory_path : String) -> Array:
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




static func pCheckDirectoryPath(path : String, dir : Directory) -> String:
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





static func loadAsyncFrom(file_path : String, object, function_name : String) -> ResourceLoaderAsync:
	var func_ref : FuncRef = FuncRef.new()
	func_ref.set_instance(object)
	func_ref.set_function(function_name)
	var rla : ResourceLoaderAsync = ResourceLoaderAsync.new(file_path, func_ref)
	return rla



#-----------------------------IS NOT WORKING------------------------------------
#thread.start(DirectoryLoader) probably creates a cyclic reference 

#static func loadAsyncAllDeepFrom(directory_path : String, finished_func : FuncRef) -> void:
#	var thread : Thread = Thread.new()
#	thread.start(DirectoryLoader, "loadAllDeepFrom", directory_path)
#	finished_func.call_func(thread.wait_to_finish())
