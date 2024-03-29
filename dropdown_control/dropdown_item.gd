class_name DropdownItem

var texture: Texture2D
var value
var label: String

func _init(val, lbl, tex):
	value = val
	label = lbl
	texture = tex
