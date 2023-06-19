@tool
extends EditorPlugin

class LogcatDebuggerPlugin extends EditorDebuggerPlugin:
	var editor_plugin : EditorPlugin
	
	func _setup_session(session_id):
		# Add a new tab in the debugger session UI containing a label.
		var session = get_session(session_id)
		# Listens to the session started and stopped signals.
		session.started.connect(func (): print("Session started"))
		session.stopped.connect(func (): print("Session stopped"))
	
		var _logcat_scene := preload("res://addons/android-debug-tools/logcat_editor_debugger.tscn").instantiate()
		_logcat_scene.editor_plugin = editor_plugin.get_editor_interface().get_editor_settings()
		_logcat_scene.editor_theme = editor_plugin.get_editor_interface().get_base_control().theme
		
		session.add_session_tab(_logcat_scene)

var _logcat_debugger : LogcatDebuggerPlugin

func _get_plugin_icon():
	get_editor_interface().get_base_control().get_theme_icon("Node", "EditorIcons")

func _enter_tree():
	_logcat_debugger = LogcatDebuggerPlugin.new()
	_logcat_debugger.editor_plugin = self
	# Initialization of the plugin goes here.
	add_debugger_plugin(_logcat_debugger)


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_debugger_plugin(_logcat_debugger)
