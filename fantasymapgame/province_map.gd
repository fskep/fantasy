extends Node2D

var province_colors = {
	Color("#7ac690"): "Malolino",
	Color("#85b293"): "Alnuia",
	Color("#75cb96"): "Cencia",
	# ... (전체 149개 추가)
}

@onready var map_sprite = $MapSprite
@onready var mask_sprite = $ProvinceMask
var mask_image : Image

func _ready():
	mask_image = Image.new()
	mask_image.load("res://assets/province_mask.png")
	mask_sprite.visible = false

func color_distance(c1: Color, c2: Color) -> float:
	return sqrt(
		pow(c1.r - c2.r, 2) +
		pow(c1.g - c2.g, 2) +
		pow(c1.b - c2.b, 2)
	)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var local_pos = map_sprite.to_local(event.position)
		var img_x = int(local_pos.x)
		var img_y = int(local_pos.y)
		if img_x < 0 or img_y < 0 or img_x >= mask_image.get_width() or img_y >= mask_image.get_height():
			return
		var color = mask_image.get_pixel(img_x, img_y)
		var found_name = ""
		for key in province_colors.keys():
			if color_distance(color, key) < 0.05:
				found_name = province_colors[key]
				break
		if found_name != "":
			print("Clicked province: %s" % found_name)
