import GameplayKit
import SpriteKit

class EntityManager {
    // Master list of everything in the game
    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()
    let scene: SKScene

    // Component Systems (The Update Loop)
    lazy var componentSystems: [GKComponentSystem] = {
        // The Agent System handles physics/movement for everyone at once
        let agentSystem = GKComponentSystem(componentClass: GKAgent2D.self)
        return [agentSystem]
    }()

    init(scene: SKScene) {
        self.scene = scene
    }

    func add(_ entity: GKEntity) {
        entities.insert(entity)

        // If it has a sprite, show it in the world
        if let spriteNode = entity.component(ofType: GKSKNodeComponent.self)?.node {
            scene.addChild(spriteNode)
        }

        // Register components to systems so they get updated
        for system in componentSystems {
            system.addComponent(foundIn: entity)
        }
    }

    func update(_ deltaTime: CFTimeInterval) {
        // Update all logic (Movement math happens here)
        for system in componentSystems {
            system.update(deltaTime: deltaTime)
        }
    }
}