extends Control

## The FastNoiseLite object.
@onready var noise: FastNoiseLite = $SeamlessNoiseTexture.texture.noise
@onready var tile_map_layer: TileMapLayer = $TileMapLayer


# Various noise parameters.
var min_noise: float = -1.0
var max_noise: float = 1.0


func _ready() -> void:
	# Set up noise with basic info.
	$ParameterContainer/SeedSpinBox.value = noise.seed
	$ParameterContainer/FrequencySpinBox.value = noise.frequency
	$ParameterContainer/FractalOctavesSpinBox.value = noise.fractal_octaves
	$ParameterContainer/FractalGainSpinBox.value = noise.fractal_gain
	$ParameterContainer/FractalLacunaritySpinBox.value = noise.fractal_lacunarity

	# Render the noise.
	_refresh_shader_params()


func _refresh_shader_params() -> void:
	#$SeamlessNoiseTexture.texture = noise.get_image(512,512)
	# Adjust min/max for shader.
	@warning_ignore("integer_division")
	var _min := (min_noise + 1) / 2
	@warning_ignore("integer_division")
	var _max := (max_noise + 1) / 2
	var _material: ShaderMaterial = $SeamlessNoiseTexture.material
	_material.set_shader_parameter(&"min_value", _min)
	_material.set_shader_parameter(&"max_value", _max)
	_update_tilemap()


func _update_tilemap() -> void :
	tile_map_layer.clear()
	for y in range(32):
		for x in range(32):
			var val := noise.get_noise_2dv(Vector2(x, y))
			if val > 0.51 and val < 0.56:
				tile_map_layer.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))


func _on_documentation_button_pressed() -> void:
	OS.shell_open("https://docs.godotengine.org/en/latest/classes/class_fastnoiselite.html")


func _on_random_seed_button_pressed() -> void:
	$ParameterContainer/SeedSpinBox.value = floor(randf_range(-2147483648, 2147483648))
	_refresh_shader_params()


func _on_seed_spin_box_value_changed(value: float) -> void:
	noise.seed = int(value)
	_refresh_shader_params()


func _on_frequency_spin_box_value_changed(value: float) -> void:
	noise.frequency = value
	_refresh_shader_params()


func _on_fractal_octaves_spin_box_value_changed(value: float) -> void:
	noise.fractal_octaves = int(value)
	_refresh_shader_params()


func _on_fractal_gain_spin_box_value_changed(value: float) -> void:
	noise.fractal_gain = value
	_refresh_shader_params()


func _on_fractal_lacunarity_spin_box_value_changed(value: float) -> void:
	noise.fractal_lacunarity = value
	_refresh_shader_params()


func _on_min_clip_spin_box_value_changed(value: float) -> void:
	min_noise = value
	_refresh_shader_params()


func _on_max_clip_spin_box_value_changed(value: float) -> void:
	max_noise = value
	_refresh_shader_params()
