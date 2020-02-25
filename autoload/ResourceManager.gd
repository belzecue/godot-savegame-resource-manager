extends Node




#the reference to the async loader has to be kept until it is finished
var rla : ResourceLoaderAsync
var dla : DirectoryLoaderAsync




func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		#var c = ResourceLoader.load("res://test-resources/a/Curve_Test_01.tres", "Curve")
		#var curve = DirectoryLoader.loadFrom("res://test-resources/a/Curve_Test_01.tres", "Curve")
		#var curves : Array = DirectoryLoader.loadAllFrom("res://test-resources", "Curve", true)
		#print("Loaded: " + str(curves))
		#loadResourceAsync()
		loadResourcesAsync()




func loadResourcesAsync() -> void:
	dla = DirectoryLoader.asyncLoadAllFrom("res://test-resources", self, "asyncLoadAllStateChange", "Curve", true)

func loadResourceAsync() -> void:
	rla = DirectoryLoader.asyncLoadFrom("res://level/TestScene_InteractiveLoader.tscn", self, "asyncLoadStateChange")




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
