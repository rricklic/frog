class_name DialogueConditionalAchievement extends DialogueConditional

@export var achievement: String

func _init(achievement_arg: String) -> void:
	achievement = achievement_arg

func execute(node: Node) -> bool:
	var interface: AchievementManagerInterface = ManagerInterface.get_interface(node.get_tree(), AchievementManagerInterface.GROUP)
	if (interface == null):
		return false
	return interface.has_achievement(achievement)
