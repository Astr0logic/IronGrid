# IronGrid

A tactical RTS game prototype built with **SpriteKit** and **GameplayKit** using Entity-Component-System (ECS) architecture.

## Architecture Overview

IronGrid demonstrates proper ECS implementation for iOS game development:

```
┌─────────────────────────────────────────────────┐
│                   GameScene                     │
│  (Orchestrates update loop & input handling)    │
└─────────────────┬───────────────────────────────┘
                  │
         ┌────────▼────────┐
         │ EntityManager   │
         │ - entities      │
         │ - systems       │
         └────────┬────────┘
                  │
    ┌─────────────┼─────────────┐
    │             │             │
┌───▼────┐  ┌────▼─────┐  ┌───▼─────┐
│ Entity │  │  Entity  │  │ Entity  │
│ (Tank) │  │(Infantry)│  │(Artillery)│
└───┬────┘  └────┬─────┘  └───┬─────┘
    │            │            │
    └────────────┼────────────┘
                 │
         Components:
         • GKAgent2D (Movement)
         • GKSKNodeComponent (Visuals)
         • HealthComponent (HP)
         • SelectableComponent (Selection)
         • TeamComponent (Faction)
```

## Core Systems

### Entity Manager (`Managers/EntityManager.swift`)
- Central registry for all game entities
- Manages component systems and update loops
- Handles entity lifecycle (add/remove)

### Component Systems
Components are data containers, systems provide behavior:

- **Movement System** - `GKAgent2D` handles pathfinding and steering
- **Health System** - Damage, death, health bar rendering
- **Selection System** - Click detection and visual feedback

### Factory Pattern (`Factory/UnitFactory.swift`)
Creates pre-configured entities:
- **Tank**: Slow, heavily armored
- **Infantry**: Fast, light units
- **Artillery**: Long-range, slow

## Project Structure

```
IronGrid/
├── GameScene.swift              # Main game scene
├── Managers/
│   └── EntityManager.swift      # ECS core manager
├── ECS/
│   ├── Components/              # Data components
│   │   ├── HealthComponent.swift
│   │   ├── SelectableComponent.swift
│   │   └── TeamComponent.swift
│   ├── Systems/                 # Behavior systems
│   └── Entities/                # Entity definitions
└── Factory/
    └── UnitFactory.swift        # Entity creation
```

## Getting Started

### Requirements
- iOS 14.0+
- Xcode 13+
- Swift 5.5+

### Setup
1. Clone the repository
2. Open in Xcode
3. Run on simulator or device
4. Tap to move units

### Controls
- **Tap Unit** - Select unit
- **Tap Ground** - Move selected unit to location
- **Multi-Select** - (Coming soon) Drag selection box

## Key Concepts

### Why ECS?
Traditional OOP inheritance creates rigid hierarchies. ECS provides:
- **Composition over inheritance** - Mix and match components
- **Data locality** - Systems process similar components together
- **Flexibility** - Add/remove capabilities at runtime

### Example: Creating a Unit
```swift
let tank = GKEntity()

// Add components
tank.addComponent(GKSKNodeComponent(node: sprite))
tank.addComponent(GKAgent2D())
tank.addComponent(HealthComponent(maxHealth: 100))
tank.addComponent(SelectableComponent())

entityManager.add(tank)
```

### Update Loop Flow
```
1. GameScene.update() called by SpriteKit
   ↓
2. EntityManager.update() runs all systems
   ↓
3. Each system updates its components
   - Movement system: Update agent positions
   - Health system: Check for deaths, update bars
   ↓
4. Sync visual nodes with agent positions
```

## Roadmap

- [x] Basic ECS architecture
- [x] Unit movement with GameplayKit
- [x] Multiple unit types
- [x] Selection system
- [x] Health system
- [ ] Team colors and factions
- [ ] Combat system
- [ ] Pathfinding with obstacles
- [ ] Formation movement
- [ ] Minimap
- [ ] Command queuing

## Technical Details

### Performance
- Component systems update in batch for cache efficiency
- Spatial partitioning for collision detection (planned)
- Object pooling for projectiles (planned)

### Design Patterns Used
- **ECS** - Core architecture
- **Factory** - Entity creation
- **Observer** - Event system (planned)
- **Command** - Order queuing (planned)

## Contributing

This is a learning project demonstrating ECS architecture in Swift. Improvements welcome!

## License

MIT License - feel free to use as reference for your own projects.
