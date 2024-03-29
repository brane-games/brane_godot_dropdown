extends Control

signal item_selected(item: String)

var dropdown_btn_scene = load("res://dropdown_control/dropdown_item_button.tscn")

var _items : Array[DropdownItem] = []
var _is_initially_selected := false
var _search_term := "" : set = _set_search_term

@export var initially_selected_value := ""
@export var panel_height := 180


func _ready():
	$ItemsPanelContainer.size.y = panel_height


func _input(event):
	if($ItemsPanelContainer.visible):
		if(event.is_pressed() and event is InputEventKey):
			var key = event.as_text_key_label()
			print("KEY: ", key)
			if(key == "Backspace"):
				_search_term = _search_term.substr(0, _search_term.length()-1)
			elif(key.length() == 1):
				_search_term += event.as_text_key_label().to_lower()


func get_selected_item_text():
	return %SelectedLabel.text


func set_items(items : Array[DropdownItem]):
	_items = items
	_clear_all_item_buttons()
	_populate_item_buttons(_items)
	if(items.size() > 0):
		if(_items[0].texture):
			%SelectedTextureRect.texture = _items[0].texture
			%SelectedTextureRect.show()
		else:
			%SelectedTextureRect.hide()
		%SelectedLabel.text = tr(items[0].label)
		_check_initial_selection()


func select_item(item_value):
	_search_term = ""
	var items = _items.filter(func(item: DropdownItem): return item.value == item_value)
	if(items.size()>0):
		_handle_btn_pressed(items[0])


func _on_dropdown_button_pressed():
	$ItemsPanelContainer.visible = !$ItemsPanelContainer.visible
	if($ItemsPanelContainer.visible):
		var global_pos = $ItemsPanelContainer.global_position + Vector2(0, 0)
		$ItemsPanelContainer.top_level = true
		$ItemsPanelContainer.global_position = global_pos
	else:
		_search_term = ""


func _clear_all_item_buttons():
	while(%ItemsVBoxContainer.get_child_count() > 1):
		var child_to_remove = %ItemsVBoxContainer.get_child(1)
		%ItemsVBoxContainer.remove_child(child_to_remove)
		child_to_remove.queue_free()

func _populate_item_buttons(items):
	for item in items:
		var dropdownItemButton = dropdown_btn_scene.instantiate()
		dropdownItemButton.connect("pressed", _handle_btn_pressed.bind(item))
		%ItemsVBoxContainer.add_child(dropdownItemButton)
		dropdownItemButton.set_item(item)


func _handle_btn_pressed(item: DropdownItem):
	if(item.texture):
		%SelectedTextureRect.texture = item.texture
		%SelectedTextureRect.show()
	else:
		%SelectedTextureRect.hide()
	%SelectedLabel.text = item.label
	emit_signal("item_selected", item.value)
	$ItemsPanelContainer.visible = false
	_search_term = ""


func set_texture_size(size: Vector2):
	%SelectedTextureRect.custom_minimum_size = size


func _check_initial_selection():
	if(initially_selected_value != "" and !_is_initially_selected):
		_is_initially_selected = true
		var to_select = _items.filter(func(item: DropdownItem): return item.value == initially_selected_value)
		if(to_select.size() > 0):
			var t = get_tree().create_tween()
			t.tween_callback(_handle_btn_pressed.bind(to_select[0])).set_delay(0.2)


func _on_clear_search_button_pressed():
	_search_term = ""


func _set_search_term(val):
	_search_term = val
	%SearchLabel.text = _search_term
	if(_search_term != ""):
		%SearchPanelContainer.show()
		var items_to_hide = _items.filter(func(item: DropdownItem): return !_search_term.is_subsequence_ofn(item.value) && !_search_term.is_subsequence_ofn(tr(item.label)))
		for index in (%ItemsVBoxContainer.get_child_count() - 1):
			var item_node = %ItemsVBoxContainer.get_child(index+1)
			var is_found_in_list = items_to_hide.any(func(item: DropdownItem): return item.value == item_node.get_value())
			if(is_found_in_list):
				item_node.hide()
			else:
				item_node.show()
	else:
		%SearchPanelContainer.hide()
		for index in (%ItemsVBoxContainer.get_child_count() - 1):
			var item_node = %ItemsVBoxContainer.get_child(index+1)
			item_node.show()

