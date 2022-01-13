extends Control

func start():
	show()
	$Anim.play("MoveDot")


func stop():
	hide()
	$Anim.stop()
