import GameplayKit
import SpriteKit

class EntityManager {
    // Master list of everything in the game
    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()
    let scene: SKScene

    // Component Systems (The Update Loop)
    lazy var componentSystems: [GKComponentSystem] = {
        let agentSystem = GKComponentSystem(componentClass: GKAgent2D.self)
        let healthSystem = GKComponentSystem(componentClass: HealthComponent.self)
        let selectableSystem = GKComponentSystem(componentClass: SelectableComponent.self)
        return [agentSystem, healthSystem, selectableSystem]
    }()

    init(scene: SKScene) {
        self.scene = scene
    }

    func add(_ entity: GKEntity) {
        entities.insert(entity)

        // If it has a sprite, show it in the world
        if let spriteNode = entity.component(ofType: GKSKNodeComponent.self)?.node {
            scene.addChild(spriteNode)

            // Attach health bar if entity has both components
            if let healthBar = entity.component(ofType: HealthBarComponent.self) {
                healthBar.attachTo(node: spriteNode)
            }
        }

        // Register components to systems so they get updated
        for system in componentSystems {
            system.addComponent(foundIn: entity)
        }
    }

    func remove(_ entity: GKEntity) {
        // Remove sprite from scene
        if let spriteNode = entity.component(ofType: GKSKNodeComponent.self)?.node {
            spriteNode.removeFromParent()
        }

        // Remove from systems
        for system in componentSystems {
            system.removeComponent(foundIn: entity)
        }

        entities.remove(entity)
    }

    func update(_ deltaTime: CFTimeInterval) {
        // Update all logic (Movement math happens here)
        for system in componentSystems {
            system.update(deltaTime: deltaTime)
        }

        // Update health bars
        for entity in entities {
            if let health = entity.component(ofType: HealthComponent.self),
               let healthBar = entity.component(ofType: HealthBarComponent.self) {
                healthBar.updateHealth(percentage: health.healthPercentage())

                // Mark dead entities for removal
                if health.isDead {
                    toRemove.insert(entity)
                }
            }
        }

        // Remove dead entities
        for entity in toRemove {
            remove(entity)
        }
        toRemove.removeAll()
    }

    // Helper to find entity at position (for selection)
    func entity(at point: CGPoint) -> GKEntity? {
        for entity in entities {
            if let node = entity.component(ofType: GKSKNodeComponent.self)?.node {
                if node.contains(point) {
                    return entity
                }
            }
        }
        return nil
    }
}