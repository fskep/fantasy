extends Node2D

# 색상-프로빈스ID 매핑 (예시, 일부만)
var province_colors = {
	Color.hex("7ac690"): "Malolino",
	Color.hex("85b293"): "Alnuia",
	Color.hex("75cb96"): "Cencia",
	# ... (전체 149개 추가)
}

@onready var map_sprite = $MapSprite
@onready var mask_sprite = $ProvinceMask
var mask_image : Image

func _ready():
	# 마스크 이미지 불러오기 & 숨기기
	var mask_tex = mask_sprite.texture
	mask_image = mask_tex.get_image()
	mask_image.lock()
	mask_sprite.visible = false

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var local_pos = map_sprite.to_local(event.position)
		var img_x = int(local_pos.x)
		var img_y = int(local_pos.y)
		if img_x < 0 or img_y < 0 or img_x >= mask_image.get_width() or img_y >= mask_image.get_height():
			return
		var color = mask_image.get_pixel(img_x, img_y)
		# 근사치 허용 (색상 오차로 인한 잘못된 인식 방지)
		var found_name = ""
		for key in province_colors.keys():
			if color.distance_to(key) < 0.05:
				found_name = province_colors[key]
				break
		if found_name != "":
			print("Clicked province: %s" % found_name)
			# 여기서 UI업데이트 등 원하는 동작 추가
