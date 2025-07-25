extends CharacterBody2D

signal health_depleted

var health := 100.0
const MAX_HEALTH := 100.0

# Damage settings
const DAMAGE_RATE := 5.0

# Regeneration settings
const REGEN_DELAY := 2.0         # seconds without damage before regen starts
const REGEN_RATE := 5.0          # hp per second

# Internal timer
var time_since_damage := 0.0

func _physics_process(delta):
	# Movement
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 600
	move_and_slide()

	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else:
		$HappyBoo.play_idle_animation()

	# Damage Detection
	var took_damage := false
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		var total_damage = DAMAGE_RATE * overlapping_mobs.size() * delta
		health -= total_damage
		time_since_damage = 0.0  # Reset timer
		took_damage = true
	else:
		time_since_damage += delta

	# Regeneration Logic
	if not took_damage and time_since_damage >= REGEN_DELAY and health < MAX_HEALTH:
		health += REGEN_RATE * delta
		health = min(health, MAX_HEALTH)  # Clamp to max

	# Update health bar
	%PlayerHealthBar.value = health

	# Emit signal if health is gone
	if health <= 0.0:
		health_depleted.emit()
