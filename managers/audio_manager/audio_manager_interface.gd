class_name AudioManagerInterface extends ManagerInterface

func play_audio(audio_stream: AudioStream, pitch_scale: float = 1.0) -> void:
	var manager: AudioManager = _get_or_create_manager()
	manager.play_audio(audio_stream, pitch_scale)
	
func play_music(audio_stream: AudioStream) -> void:
	var manager: AudioManager = _get_or_create_manager()
	manager.play_music(audio_stream)
	
func fade_out_volume(duration: float) -> void:
	var manager: AudioManager = _get_or_create_manager()
	manager.fade_out_volume(duration)
