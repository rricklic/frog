class_name Dialogue extends Resource

@export var text: Array[String]
@export var responses: Array[DialogueResponse]
@export var portrait: Texture
@export var cursor: Texture
@export var sound: AudioStream

# timeline - 
# series of
#   1. spoken dialogue
#   2. responses
#     2a. conditional based on response

# wait/delay
