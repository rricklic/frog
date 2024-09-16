class_name DialogueActionAchievement extends DialogueAction

@export var achivement: String

func _init(achivement_arg: String) -> void:
	achivement = achivement_arg

func execute(node: Node) -> void:
	var interface: AchievementManagerInterface = ManagerInterface.get_interface(node.get_tree(), AchievementManagerInterface.GROUP)
	if (interface == null):
		return
	interface.add_achievement(achivement)
