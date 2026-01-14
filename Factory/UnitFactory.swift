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