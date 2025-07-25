extends ProgressBar

# Health color thresholds
const FULL_HEALTH_COLOR = Color(0.0, 1.0, 0.2)     # Bright green
const MID_HEALTH_COLOR  = Color(1.0, 0.85, 0.0)    # Vibrant yellow
const LOW_HEALTH_COLOR  = Color(1.0, 0.0, 0.0)     # Deep red

# New threshold for color transition point
const MID_HEALTH_THRESHOLD = 0.7  # 70% health

func _process(delta):
	update_health_color()

func update_health_color():
	var hp_percent = value / max_value  # Normalized 0.0 to 1.0

	var bar_color: Color
	if hp_percent > MID_HEALTH_THRESHOLD:
		# From GREEN → YELLOW (above 70%)
		var t = (hp_percent - MID_HEALTH_THRESHOLD) / (1.0 - MID_HEALTH_THRESHOLD)
		bar_color = MID_HEALTH_COLOR.lerp(FULL_HEALTH_COLOR, t)
	else:
		# From RED → YELLOW (below 70%)
		var t = hp_percent / MID_HEALTH_THRESHOLD
		bar_color = LOW_HEALTH_COLOR.lerp(MID_HEALTH_COLOR, t)

	self.modulate = bar_color
