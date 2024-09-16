class_name AchievementManagerInterface extends ManagerInterface

const GROUP: String = "AchievementManagerInterface"

# TODO:

func _ready() -> void:
	add_to_group(GROUP)

func add_achievement(achivement: String) -> void:
	print("add_achievement:" + achivement)
	pass # TODO:
	
func has_achievement(achivement: String) -> bool:
	print("has_achievement:" + achivement)
	return true
