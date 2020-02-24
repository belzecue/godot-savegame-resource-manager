extends Node



var async_loader : ResourceAsyncLoader = ResourceAsyncLoader.new()
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



func _ready() -> void:
	async_loader.connect("Loading_Finished", self, "On_Loading_Finished")
	async_loader.connect("Poll_Update", self, "On_Poll_Update")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		async_loader.startLoading("res://level/TestScene_InteractiveLoader.tscn")

func On_Loading_Finished(resource) -> void:
	print("Finished. Resource loaded: " + str(resource))
#	async_loader.disconnect("Loading_Finished", self, "On_Loading_Finished")
#	async_loader.disconnect("Poll_Update", self, "On_Poll_Update")
#	async_loader = ResourceAsyncLoader.new()
#	async_loader.connect("Loading_Finished", self, "On_Loading_Finished")
#	async_loader.connect("Poll_Update", self, "On_Poll_Update")

func On_Poll_Update(p : float) -> void:
	print("Poll Update: " + str(p))




class ResourceAsyncLoader:
	signal Loading_Finished(resource)
	signal Poll_Update(percentage)
	
	
	
	
	enum LOAD_STATE {FAILED = -1, STARTED = 0, LOADING = 1, CACHED = 2}
	
	
	var thread : Thread
	var interactive_loader : ResourceInteractiveLoader
	var res = null
	
	
	
	
	func getResource():
		return res

	
	func startLoading(path : String) -> int:
		if !ResourceLoader.exists(path):
			print("Async load of failed. %s does not exist." %path)
			return LOAD_STATE.FAILED
		if res:
			emit_signal("Loading_Finished", res)
			return LOAD_STATE.CACHED
		if ResourceLoader.has_cached(path):
			print("IS ALREAD CACHED")
			res = ResourceLoader.load(path)
			emit_signal("Loading_Finished", res)
			return LOAD_STATE.CACHED

		if thread and thread.is_active():
			return LOAD_STATE.LOADING
		
		thread = Thread.new()
		interactive_loader = ResourceLoader.load_interactive(path)
		thread.start(self,"threadLoading", 0)
		return LOAD_STATE.STARTED
	
	
	func threadLoading(thread_id):
		while (true):
			print("P")
			var err = interactive_loader.poll()
			if err == OK:
				var p : float = interactive_loader.get_stage() as float / interactive_loader.get_stage_count() as float
				emit_signal("Poll_Update", p)
			elif(err == ERR_FILE_EOF):
				res = interactive_loader.get_resource()
				break
			else:
				break
		
		call_deferred("loadingFinished")
		thread.wait_to_finish()
	
	
	func loadingFinished() -> void:
		thread = null
		interactive_loader = null
		emit_signal("Loading_Finished", res)
	
	
	func _notification(what: int) -> void:
		if what == 1:
			if interactive_loader:
				interactive_loader = null
			if thread and thread.is_active():
				thread.wait_to_finish()













