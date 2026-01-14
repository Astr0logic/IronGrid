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