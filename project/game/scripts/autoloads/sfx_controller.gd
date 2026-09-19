extends Node

const _AUDIO_STREAM_POOL_SIZE := 8

var drill_sound_effect_path: AudioStream = preload("uid://cw21ggpr8bk8")

var _audio_stream_player_pool: Array[AudioStreamPlayer]

var _drill_stream_player: AudioStreamPlayer


func _ready() -> void:
	for i in _AUDIO_STREAM_POOL_SIZE:
		var audio_stream_player := AudioStreamPlayer.new()
		audio_stream_player.bus = "SFX"

		_audio_stream_player_pool.append(audio_stream_player)
		add_child(audio_stream_player)

	_drill_stream_player = AudioStreamPlayer.new()
	_drill_stream_player.bus = "SFX"
	add_child(_drill_stream_player)


func play(
	audio_stream: AudioStream,
	pitch_variation: float = 0.0,
	override_pool_size := false,
) -> void:
	for player in _audio_stream_player_pool:
		if not player.playing:
			player.stream = audio_stream
			player.pitch_scale = 1.0 + randf_range(-pitch_variation, pitch_variation)
			player.play()
			return

	if override_pool_size:
		var player := AudioStreamPlayer.new()
		player.bus = "SFX"
		player.stream = audio_stream
		player.pitch_scale = 1.0 + randf_range(-pitch_variation, pitch_variation)
		player.finished.connect(player.queue_free)
		add_child(player)
		player.play()


func play_drill() -> void:
	_drill_stream_player.play()


func stop_drill() -> void:
	_drill_stream_player.pause()
