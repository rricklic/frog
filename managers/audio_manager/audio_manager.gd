class_name AudioManager extends Manager

#
# Plays audio (sounds, music)
# Implements a cache of AudioStreamPlayer instances to minimize 
# any overhead of instantiating.
#
# Fade in/out volume control
#

@export var size: int = 8

const GROUP: StringName = "AudioManager"
const AUDIO_BUS_NAME: String = "master"
const NO_VOLUME: float = -100.0
const FULL_VOLUME: float = 0.0

var music_player: AudioStreamPlayer
var audio_players: Array[AudioStreamPlayer] = []  # The available players.
var audio_queue: Array[AudioStream] = []  # The queue of sounds to play.
var audio_queue_pitch_scale: Array[float] = []

func _ready():
	add_to_group(GROUP)
	music_player = _create_audio_player()
	for i: int in size:
		var audio_player: AudioStreamPlayer = _create_audio_player()
		audio_players.push_back(audio_player)
		audio_player.finished.connect(_on_audio_stream_player_finished.bind(audio_player))

func _create_audio_player() -> AudioStreamPlayer:
	var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.bus = AUDIO_BUS_NAME
	return audio_player

func _on_audio_stream_player_finished(audio_player: AudioStreamPlayer):
	audio_players.push_back(audio_player)

func play_audio(audio_stream: AudioStream, pitch_scale: float = 1.0) -> void:
	audio_queue.push_back(audio_stream)
	audio_queue_pitch_scale.push_back(pitch_scale)

func _play(audio_stream: AudioStream) -> void:
	if (!audio_players.is_empty()):
		var index: int = audio_players.size() - 1
		audio_players[index].stream = audio_stream
		audio_players[index].play()
		audio_players.pop_back()

func _process(delta: float) -> void:
	if !audio_queue.is_empty() && !audio_players.is_empty():
		var index: int = audio_players.size() - 1
		audio_players[index].stream = audio_queue.pop_front()
		audio_players[index].pitch_scale = audio_queue_pitch_scale.pop_front()
		audio_players[index].play()
		audio_players.pop_back()
	
func play_music(audio_stream: AudioStream):
	music_player.stream = audio_stream
	music_player.play()
	if (!music_player.finished.is_connected(play_music.bind(audio_stream))):
		music_player.finished.connect(play_music.bind(audio_stream))
	await music_player.finished

func stop_music():
	music_player.stop()
	
func pause_music():
	music_player.set_stream_paused(!music_player.get_stream_paused())

func fade_out_volume(duration: float) -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EaseType.EASE_IN)
	tween.set_trans(Tween.TransitionType.TRANS_EXPO)
	tween.set_parallel(true)
	for audio_player: AudioStreamPlayer in get_children():
		tween.tween_property(audio_player, "volume_db", NO_VOLUME, duration)

func fade_in_volume(duration: float) -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EaseType.EASE_IN)
	tween.set_trans(Tween.TransitionType.TRANS_EXPO)
	tween.set_parallel(true)
	for audio_player: AudioStreamPlayer in get_children():
		tween.tween_property(audio_player, "volume_db", FULL_VOLUME, duration).from(NO_VOLUME)

func reset_volume() -> void:
	music_player.volume_db = FULL_VOLUME
	for audio_player: AudioStreamPlayer in get_children():
		audio_player.volume_db = FULL_VOLUME
