import os

# The directory structure and file contents for "IronGrid"
project_structure = {
    "Managers": {},
    "ECS": {
        "Entities": {},
        "Components": {},
        "Systems": {}
    },
    "Factory": {}
}

# The Swift Code Contents
files = {
    "Managers/EntityManager.swift": """
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
""",

    "Factory/UnitFactory.swift": """
import GameplayKit
import SpriteKit

class UnitFactory {
    static func createTank(at position: CGPoint) -> GKEntity {
        let tank = GKEntity()

        // 1. Visuals (The Green Square)
        let sprite = SKSpriteNode(color: .green, size: CGSize(width: 40, height: 40))
        sprite.position = position
        sprite.name = "Tank" // Useful for debugging
        tank.addComponent(GKSKNodeComponent(node: sprite))

        // 2. Movement Brain (Agent)
        let agent = GKAgent2D()
        agent.radius = 20
        agent.maxSpeed = 200
        agent.maxAcceleration = 100
        agent.mass = 1
        agent.position = vector_float2(Float(position.x), Float(position.y))

        // 3. Friction (Stop nicely when not moving)
        agent.behavior = GKBehavior(goal: GKGoal(toReachTargetSpeed: 0), weight: 0.1)

        tank.addComponent(agent)

        return tank
    }
}
""",

    "GameScene.swift": """
import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var entityManager: EntityManager!
    var lastUpdateTime: TimeInterval = 0
    var selectedTank: GKEntity?

    override func didMove(to view: SKView) {
        // Initialize the Entity Manager
        entityManager = EntityManager(scene: self)

        // Spawn our Hero Tank in the center
        let tank = UnitFactory.createTank(at: CGPoint(x: 0, y: 0))
        entityManager.add(tank)

        // Auto-select it for this demo
        selectedTank = tank
    }

    override func touchDown(atPoint pos: CGPoint) {
        // Check if we have a tank and it has a movement brain
        guard let tank = selectedTank,
              let agent = tank.component(ofType: GKAgent2D.self) else { return }

        // Create a temporary "Target" agent at the touch location
        let targetAgent = GKAgent2D()
        targetAgent.position = vector_float2(Float(pos.x), Float(pos.y))

        // Tell the tank: "Seek this target with 100% effort"
        agent.behavior = GKBehavior(goal: GKGoal(toSeekAgent: targetAgent), weight: 100)
    }

    override func update(_ currentTime: TimeInterval) {
        if (self.lastUpdateTime == 0) { self.lastUpdateTime = currentTime }
        let dt = currentTime - self.lastUpdateTime

        // 1. Run the Math (GameplayKit)
        entityManager.update(dt)

        // 2. Sync the Visuals (SpriteKit)
        // This forces the sprite to follow the invisible physics agent
        for entity in entityManager.entities {
            if let agent = entity.component(ofType: GKAgent2D.self),
               let nodeComponent = entity.component(ofType: GKSKNodeComponent.self) {
                nodeComponent.node.position = CGPoint(x: CGFloat(agent.position.x),
                                                      y: CGFloat(agent.position.y))
                nodeComponent.node.zRotation = CGFloat(agent.rotation)
            }
        }

        self.lastUpdateTime = currentTime
    }

    // Boilerplate touch handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {}
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {}
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
}
"""
}

def create_project():
    print("🚀 Initializing Iron Grid Protocol...")

    # 1. Create Directories
    for folder in project_structure:
        if not os.path.exists(folder):
            os.makedirs(folder)
            print(f"Created folder: {folder}")

    # 2. Create Recursive Directories (ECS subfolders)
    for subfolder in project_structure["ECS"]:
        path = os.path.join("ECS", subfolder)
        if not os.path.exists(path):
            os.makedirs(path)
            print(f"Created folder: {path}")

    # 3. Write Files
    for filepath, content in files.items():
        with open(filepath, "w") as f:
            f.write(content.strip())
        print(f"✅ Generated: {filepath}")

    print("\\nDONE. Open Xcode, delete the old GameScene.swift, and drag these new folders into your project navigator.")

if __name__ == "__main__":
    create_project()
