extends Node

#the reference to the async loader has to be kept until it is finished
var rla : ResourceLoaderAsync

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		loadResourceAsync()


func loadResourceAsync() -> void:
	rla = DirectoryLoader.loadAsyncFrom("res://level/TestScene_InteractiveLoader.tscn", self, "asyncLoadStateChange")


func asyncLoadStateChange(p : float, res) -> void:
	if p < 1.0:
		print("Poll Update: " + str(p))
	else:
		print("Finished. Resource loaded: " + str(res))
		rla = null
