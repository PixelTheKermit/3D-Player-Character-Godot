extends KinematicBody


# Variables
var speed = 10
var move = Vector3(0, 0, 0)
var sens = 0.2
var vscalemult = 1

# OnReady Variables
onready var viewport = get_node("ViewportContainer")
onready var camerapos = get_node("CameraPos")
onready var slider = get_node("Hud/HSlider")

func _ready():
	# Camera manipulation stuff here
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	viewport.get_node("Viewport").get_texture().flags = Texture.FLAG_FILTER
	var _shut = get_viewport().connect("size_changed", self, "_root_viewport_size_changed")
	# Slider stuff here
	slider.get_node("Label").text = "current res scale: " + str(slider.value) + "%"

func _root_viewport_size_changed():
	viewport.get_node("Viewport").size = viewport.get_viewport().size*vscalemult


func _input(event):
	if event is InputEventMouseMotion:
		var movement = event.relative
		camerapos.rotation.x += -deg2rad(movement.y*sens)
		camerapos.rotation.x = clamp(camerapos.rotation.x, deg2rad(-90), deg2rad(90))
		rotation.y += -deg2rad(movement.x*sens)

func _physics_process(_delta):
	if vscalemult != slider.value/100:
		vscalemult = slider.value/100
		_root_viewport_size_changed()
		slider.get_node("Label").text = "current res scale: " + str(slider.value) + "%"
	
	# Viewport camera stuff here
	
	viewport.get_node("Viewport/Camera").global_transform = camerapos.global_transform
	
	
	# Movement code down here
	move.x = 0
	move.z = 0
	
	if Input.is_action_pressed("w"):
		move.z = -speed
	elif Input.is_action_pressed("s"):
		move.z = speed
	if Input.is_action_pressed("a"):
		move.x = -speed
	elif Input.is_action_pressed("d"):
		move.x = speed
	
	if Input.is_action_pressed("jump") and is_on_floor():
		move.y = 20
	elif !is_on_floor():
		move.y -= 1
	elif move.y < 0:
		move.y = 0
	
	
	var rotvec = Vector3(0, rotation.y, 0).normalized()
	if rotvec.is_normalized():
		move = move.rotated(rotvec*rotvec, rotation.y)
	var _shutup = move_and_slide(move, Vector3(0, 100, 0))



