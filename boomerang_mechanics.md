# BOOMERANGELIC: Core Gameplay Mechanics

## Player Control System
- YOU are the boomerang
- Control trajectory mid-flight using arrow keys/mouse
- Wielder handles the throwing
- Your control affects wielder's next throw

## Basic Flight Controls
- Left/Right: Curve trajectory
- Up/Down: Adjust height
- Space: Speed boost
- Shift: Slow time briefly
- Mouse: Fine-tune adjustments

## Throw Types & Mechanics

### Panicked Rookie
```
Base Throw: Random Direction
- Initial trajectory is randomized within 90° cone
- More power = wider cone
- Player can correct course mid-flight
- Hitting targets increases wielder confidence
```

Mechanics:
1. Flail-and-Pray
   - Random velocity changes every 0.5 seconds
   - Player can "lean into" random changes for bonus speed
   - Critical hits on accidental targets
   - Chain bounces increase luck multiplier

2. Backwards Toss
   - 180° initial direction
   - 2x control during correction
   - Rear hits deal bonus damage
   - Builds "Confusion Meter"

### Overconfident Barbarian
```
Base Throw: Maximum Force
- Straight line, high speed
- Heavy screen shake
- Breaking objects builds combo
- Overshooting reduces confidence
```

Mechanics:
1. MAXIMUM POWER
   - Hold throw button to charge
   - Charge too long = wielder falls over
   - Break through destructible walls
   - Create damaging shockwave trail

2. Spin-to-Win
   - Spiral pattern expands outward
   - Player controls spiral tightness
   - Dizzy meter affects next throw
   - Creates temporary vortex

### Physics Expert
```
Base Throw: Calculated Path
- Shows trajectory prediction line
- Long wind-up animation
- Perfect accuracy (if uninterrupted)
- Enemies can disrupt calculations
```

Mechanics:
1. Calculated Arc
   - Lock-on up to 3 targets
   - Chain precise hits
   - Bonus damage for geometry
   - Draw trajectory in advance

2. Quantum Uncertainty
   - Create phantom trajectories
   - Switch between paths mid-flight
   - Enemies dodge wrong paths
   - Merge paths for bonus damage

### Retired Juggler
```
Base Throw: Style Points
- Basic throws have flair animations
- Damage scales with style meter
- Crowd reactions affect performance
- Chain tricks for combos
```

Mechanics:
1. Show-off Special
   - Time button presses for tricks
   - Build applause meter
   - Create temporary audience
   - Style points = damage multiplier

2. Triple Ricochet
   - Mark bounce points in advance
   - Each bounce adds effect
   - Final bounce creates explosion
   - Jazz hands stun enemies

## Advanced Mechanics

### Wielder State System
```
States affect throws:
- Confidence (accuracy)
- Stress (power)
- Style (effects)
- Learning (evolution)
```

### Environmental Interactions
```
- Bounce off walls
- Cut through water
- Ricochet off enemies
- Interact with physics objects
```

### Combo System
```
Chain together:
- Multiple hits
- Bounce patterns
- Style points
- Environmental tricks
```

### Upgrade System
```
Wielders can learn:
- New throw variations
- Special techniques
- Wrong lessons
- Questionable improvements
```

## Technical Implementation Notes
1. Physics System
   - Custom trajectory calculations
   - Bounce prediction
   - Collision detection
   - Force application

2. State Management
   - Wielder behavior trees
   - Throw pattern recognition
   - Style scoring system
   - Learning progression

3. Visual Feedback
   - Trajectory trails
   - Impact effects
   - Style indicators
   - Crowd reactions 