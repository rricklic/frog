class_name AudioManagerInterface extends ManagerInterface

func _ready() -> void:
	_setup(AudioManager.GROUP)

func play_audio(audio_stream: AudioStream, pitch_scale: float = 1.0) -> void:
	var audio_manager: AudioManager = _get_manager()
	audio_manager.play_audio(audio_stream, pitch_scale)
	
func play_music(audio_stream: AudioStream) -> void:
	var audio_manager: AudioManager = _get_manager()
	audio_manager.play_music(audio_stream)
	
func fade_out_volume(duration: float) -> void:
	var audio_manager: AudioManager = _get_manager()
	audio_manager.fade_out_volume(duration)
