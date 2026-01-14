import GameplayKit
import SpriteKit

enum UnitType {
    case tank
    case infantry
    case artillery
}

class UnitFactory {
    // Main factory method
    static func createUnit(type: UnitType, at position: CGPoint, team: Team = .player) -> GKEntity {
        switch type {
        case .tank:
            return createTank(at: position, team: team)
        case .infantry:
            return createInfantry(at: position, team: team)
        case .artillery:
            return createArtillery(at: position, team: team)
        }
    }

    // MARK: - Tank (Slow, Heavy, High HP)
    static func createTank(at position: CGPoint, team: Team = .player) -> GKEntity {
        let tank = GKEntity()

        // Visuals
        let sprite = SKSpriteNode(color: team.color, size: CGSize(width: 40, height: 40))
        sprite.position = position
        sprite.name = "Tank"
        tank.addComponent(GKSKNodeComponent(node: sprite))

        // Movement (Slow)
        let agent = GKAgent2D()
        agent.radius = 20
        agent.maxSpeed = 100
        agent.maxAcceleration = 80
        agent.mass = 2.0
        agent.position = vector_float2(Float(position.x), Float(position.y))
        agent.behavior = GKBehavior(goal: GKGoal(toReachTargetSpeed: 0), weight: 0.1)
        tank.addComponent(agent)

        // Stats
        tank.addComponent(HealthComponent(maxHealth: 150))
        tank.addComponent(SelectableComponent())
        tank.addComponent(TeamComponent(team: team))
        tank.addComponent(HealthBarComponent())

        return tank
    }

    // MARK: - Infantry (Fast, Light, Low HP)
    static func createInfantry(at position: CGPoint, team: Team = .player) -> GKEntity {
        let infantry = GKEntity()

        // Visuals (Smaller circle)
        let sprite = SKSpriteNode(color: team.color, size: CGSize(width: 20, height: 20))
        sprite.position = position
        sprite.name = "Infantry"
        infantry.addComponent(GKSKNodeComponent(node: sprite))

        // Movement (Fast)
        let agent = GKAgent2D()
        agent.radius = 10
        agent.maxSpeed = 250
        agent.maxAcceleration = 200
        agent.mass = 0.5
        agent.position = vector_float2(Float(position.x), Float(position.y))
        agent.behavior = GKBehavior(goal: GKGoal(toReachTargetSpeed: 0), weight: 0.1)
        infantry.addComponent(agent)

        // Stats
        infantry.addComponent(HealthComponent(maxHealth: 50))
        infantry.addComponent(SelectableComponent())
        infantry.addComponent(TeamComponent(team: team))
        infantry.addComponent(HealthBarComponent())

        return infantry
    }

    // MARK: - Artillery (Slow, Long Range, Medium HP)
    static func createArtillery(at position: CGPoint, team: Team = .player) -> GKEntity {
        let artillery = GKEntity()

        // Visuals (Hexagon)
        let sprite = SKSpriteNode(color: team.color, size: CGSize(width: 35, height: 35))
        sprite.position = position
        sprite.name = "Artillery"
        artillery.addComponent(GKSKNodeComponent(node: sprite))

        // Movement (Very Slow)
        let agent = GKAgent2D()
        agent.radius = 17
        agent.maxSpeed = 60
        agent.maxAcceleration = 50
        agent.mass = 1.5
        agent.position = vector_float2(Float(position.x), Float(position.y))
        agent.behavior = GKBehavior(goal: GKGoal(toReachTargetSpeed: 0), weight: 0.1)
        artillery.addComponent(agent)

        // Stats
        artillery.addComponent(HealthComponent(maxHealth: 80))
        artillery.addComponent(SelectableComponent())
        artillery.addComponent(TeamComponent(team: team))
        artillery.addComponent(HealthBarComponent())

        return artillery
    }
}