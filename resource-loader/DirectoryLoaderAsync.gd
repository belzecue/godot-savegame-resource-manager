class_name DirectoryLoaderAsync




enum FINISHED_STATE {FUNREF_INVALID = 0, PATH_INVALID = 1, NOTHING_FOUND = 2, FINISHED_LOADING = 3, LOADING = 4}


var _thread : Thread
var _finished_state : int = FINISHED_STATE.LOADING
var _file_paths : Array = []
var _type_hint : String = ""




func _init(path : String, func_ref : FuncRef, type_hint : String = "", deep : bool = false) -> void:
	if !func_ref.is_valid(): 
		print("Function reference not valid! Either object with function is invalid or object does not have specified function.")
		push_error("Function reference not valid! Either object with function is invalid or object does not have specified function.")
		_finished_state = FINISHED_STATE.FUNREF_INVALID
		return
	
	_type_hint = type_hint
	_file_paths += pGetAllFileNames(path, deep)
	if _file_paths.size() > 0:
		_thread = Thread.new()
		_thread.start(self,"pThreadLoading", func_ref)
		_finished_state = FINISHED_STATE.LOADING


func pGetAllFileNames(path : String, deep : bool = false) -> Array:
	var file_paths : Array = []
	var dir : Directory = Directory.new()
	if !dir.dir_exists(path):
		_finished_state = FINISHED_STATE.PATH_INVALID
		return file_paths
	
	if dir.open(path) == OK:
		dir.list_dir_begin(true, false)
		var file_name : String = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				var file : String = path.plus_file(file_name)
				file_paths.append(file)
			else:
				if deep:
					var directory : String = path.plus_file(file_name)
					file_paths += pGetAllFileNames(directory, deep)
			file_name = dir.get_next()
	dir.list_dir_end()
	if file_paths.size() <= 0:
		_finished_state = FINISHED_STATE.NOTHING_FOUND
	return file_paths


func pThreadLoading(func_ref):
	var resources : Array = []
	var count_max : int = _file_paths.size()
	var count_cur : int = 0
	for file in _file_paths:
		var r = ResourceLoader.load(file, _type_hint)
		if r:
			resources.append(r)
		count_cur += 1
		if func_ref.is_valid():
			var p : float = count_cur as float / count_max as float
			func_ref.call_func(p, [])
	call_deferred("pLoadingFinished", resources, func_ref)
	_thread.wait_to_finish()


func pLoadingFinished(resources, func_ref) -> void:
	_thread = null
	_file_paths.clear()
	if func_ref.is_valid():
		func_ref.call_func(1.0, resources)
	else:
		print("Resource was sucessfully loaded but reference to function was invalid.")
		push_warning("Resource was sucessfully loaded but reference to function was invalid.")
	_finished_state = FINISHED_STATE.FINISHED_LOADING


func getFinishedState() -> int:
	return _finished_state


#func _notification(what: int) -> void:
#	if what == 1:
#		print("DESTROYED")
#		if _interactive_loader:
#			_interactive_loader = null
#		if _thread and _thread.is_active():
#			_thread.wait_to_finish()
