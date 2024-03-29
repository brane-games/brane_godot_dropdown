extends Control


var _nations := ["Angola", "Bosnia and Herzegovina", "Canada", "Denmark", "England", "France", "Germany", "Romania", "Serbia", "USA", "Zambia"]
var _icons : Array[DropdownItem] = [
	DropdownItem.new("search", "Search Icon", load("res://dropdown_control/search.svg")),
	DropdownItem.new("information", "Information Icon", load("res://dropdown_control/information.svg")),
	DropdownItem.new("down", "Down Icon", load("res://dropdown_control/down.svg")),
]

func _ready():
	# populate nation dropdown
	var nation_dropdown_items : Array[DropdownItem] = []
	for n in _nations:
		nation_dropdown_items.append(DropdownItem.new(n, n, null))
	%NationsDropdownControl.set_items(nation_dropdown_items)
	# populate resolution dropdown
	var resolution_dropdown_items : Array[DropdownItem] = [
		DropdownItem.new(Vector2(1920, 1080), "1920x1080", null),
		DropdownItem.new(Vector2(1080, 720), "1080x720", null),
		DropdownItem.new(Vector2(640, 400), "640x400", null),
		]
	%ResolutionsDropdownControl.set_items(resolution_dropdown_items)
	# populate icon dropdown
	%IconDropdownControl.set_items(_icons)


func _on_resolutions_dropdown_control_item_selected(value):
	%ResolutionLabel.text = "Resolution selected: " + var_to_str(value)


func _on_nations_dropdown_control_item_selected(item):
	%NationLabel.text = "Selected nation is " + item


func _on_icon_dropdown_control_item_selected(item):
	%IconLabel.text = "Selected icon is " + item
