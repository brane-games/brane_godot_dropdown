extends Button

var _item : DropdownItem

# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer2/ItemTextureRect.texture = null
	$HBoxContainer2/ItemLabel.text = ""


func set_item(item: DropdownItem):
	_item = item
	if(item.texture):
		$HBoxContainer2/ItemTextureRect.texture = item.texture
		$HBoxContainer2/ItemTextureRect.show()
	else:
		$HBoxContainer2/ItemTextureRect.hide()
	$HBoxContainer2/ItemLabel.text = item.label


func get_value():
	return _item.value
