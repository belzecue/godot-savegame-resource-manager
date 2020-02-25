class_name ResourceLoaderAsync




enum FINISHED_STATE {FUNREF_INVALID = 0, PATH_INVALID = 1, FINISHED_CACHED = 2, FINISHED_LOADED = 3, LOADING = 4}


var _thread : Thread
var _interactive_loader : ResourceInteractiveLoader
var _finished_state : int = FINISHED_STATE.LOADING



func _init(path : String, func_ref : FuncRef) -> void:
	if !func_ref.is_valid(): 
		print("Function reference not valid! Either object with function is invalid or object does not have specified function.")
		push_error("Function reference not valid! Either object with function is invalid or object does not have specified function.")
		_finished_state = FINISHED_STATE.FUNREF_INVALID
		return

	if !ResourceLoader.exists(path):
		print("Async load failed. %s does not exist." %path)
		push_error("Async load failed. %s does not exist." %path)
		_finished_state = FINISHED_STATE.PATH_INVALID
		return

	if ResourceLoader.has_cached(path):
		if func_ref.is_valid():
			var res = ResourceLoader.load(path)
			func_ref.call_func(1.0, res)
		print("Resource was already cached, no loading needed. Make sure to only load a resource async once.")
		push_warning("Resource was already cached, no loading needed. Make sure to only load a resource async once.")
		_finished_state = FINISHED_STATE.FINISHED_CACHED
		return

	_thread = Thread.new()
	_interactive_loader = ResourceLoader.load_interactive(path)
	_thread.start(self,"pThreadLoading", func_ref)


func pThreadLoading(func_ref):
	var res = null
	while true:
		var err = _interactive_loader.poll()
		if err == OK:
			var p : float = _interactive_loader.get_stage() as float / _interactive_loader.get_stage_count() as float
			if func_ref.is_valid():
				func_ref.call_func(p, null)
		elif err == ERR_FILE_EOF:
			res = _interactive_loader.get_resource()
			break
		else:
			break
	
	call_deferred("pLoadingFinished", res, func_ref)
	_thread.wait_to_finish()


func pLoadingFinished(res, func_ref) -> void:
	_thread = null
	_interactive_loader = null
	if func_ref.is_valid():
		func_ref.call_func(1.0, res)
	else:
		print("Resource was sucessfully loaded but reference to function was invalid.")
		push_warning("Resource was sucessfully loaded but reference to function was invalid.")
	_finished_state = FINISHED_STATE.FINISHED_LOADED


func getFinishedState() -> int:
	return _finished_state


#func _notification(what: int) -> void:
#	if what == 1:
#		print("DESTROYED")
#		if _interactive_loader:
#			_interactive_loader = null
#		if _thread and _thread.is_active():
#			_thread.wait_to_finish()
