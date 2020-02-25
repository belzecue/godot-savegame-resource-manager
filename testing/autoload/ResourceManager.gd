extends Node


#-------------------------------------------------------------------------------
#|:::::::::::::::::::::::::::::::::SHOWCASE::::::::::::::::::::::::::::::::::::|
#-------------------------------------------------------------------------------


#the reference to the async loader has to be kept until it is finished
var rla : ResourceLoaderAsync
var dla : DirectoryLoaderAsync


var array : Array = []





func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		#var c = ResourceLoader.load("res://testing/test-resources/a/Curve_Test_01.tres", "")
		#var curve = DirectoryLoaderStatic.loadFrom("res://testing/test-resources/a/Curve_Test_01.tres", "")
#		array += DirectoryLoaderStatic.loadAllFrom("res://testing/test-resources", "", true)
#		print("Loaded: " + str(array))
#		loadResourceAsync()
		loadResourcesAsync()




func loadResourcesAsync() -> void:
	dla = DirectoryLoaderStatic.asyncLoadAllFrom("res://testing/test-resources", self, "asyncLoadAllStateChange", "", true)

func loadResourceAsync() -> void:
	rla = DirectoryLoaderStatic.asyncLoadFrom("res://testing/level/TestScene_InteractiveLoader.tscn", self, "asyncLoadStateChange")




func asyncLoadStateChange(p : float, res) -> void:
	if p < 1.0:
		print("Poll Update: " + str(p))
	else:
		print("Finished. Resource loaded: " + str(res))
		rla = null

func asyncLoadAllStateChange(p : float, resources) -> void:
	if p <= 1.0 and resources.size() <= 0:
		print("Poll Update: " + str(p))
	else:
		print("Finished. Resource loaded: " + str(resources))
		dla = null

#-------------------------------------------------------------------------------
#|:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::|
#-------------------------------------------------------------------------------
