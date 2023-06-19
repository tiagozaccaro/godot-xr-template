@tool
extends HBoxContainer

# Public properties
var editor_settings : EditorSettings
var editor_theme : Theme

var thread : Thread

@onready var clear_button := $VBRight/HBTools/ClearButton
@onready var copy_button := $VBRight/HBTools/CopyButton
@onready var collapse_button := $VBRight/HBTools2/CollapseButton
@onready var show_search_button := $VBRight/HBTools2/ShowSearchButton
@onready var std_filter_button := $VBRight/StdFilterButton
@onready var error_filter_button := $VBRight/ErrorFilterButton
@onready var warning_filter_button := $VBRight/WarningFilterButton

@onready var log := $VBLeft/Log
@onready var searchBox := $VBLeft/SearchBox

# Called when the node enters the scene tree for the first time.
func _ready():
	# Log
	searchBox.right_icon = editor_theme.get_icon("Search", "EditorIcons")
	
	# Tools
	clear_button.icon = editor_theme.get_icon("Clear", "EditorIcons")
	copy_button.icon = editor_theme.get_icon("ActionCopy", "EditorIcons")
	
	# Tools 2
	collapse_button.icon = editor_theme.get_icon("CombineLines", "EditorIcons")
	show_search_button.icon = editor_theme.get_icon("Search", "EditorIcons")
	
	# Filters
	std_filter_button.icon = editor_theme.get_icon("Popup", "EditorIcons")
	error_filter_button.icon = editor_theme.get_icon("StatusError", "EditorIcons")
	warning_filter_button.icon = editor_theme.get_icon("StatusWarning", "EditorIcons")
	
	log.add_text(ProjectSettings.get_property_list())
	
	var outputs
	
	var process = OS.create_process("adb",  ["logcat", "-v color"], false)
	thread = Thread.new()
	thread.start(self, "_read_output")

func _read_output():
	while process.is_running():
		var output = process.get_output()
		if output != "":
			print(output)

		var errorOutput = process.get_error_output()
		if errorOutput != "":
			print(errorOutput)

	process.close()
	thread.wait_to_finish()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
