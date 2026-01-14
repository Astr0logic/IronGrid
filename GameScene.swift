import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var entityManager: EntityManager!
    var lastUpdateTime: TimeInterval = 0
    var selectedEntity: GKEntity?

    override func didMove(to view: SKView) {
        // Setup scene
        backgroundColor = SKColor(white: 0.15, alpha: 1.0)

        // Initialize the Entity Manager
        entityManager = EntityManager(scene: self)

        // Spawn Player Units (Green)
        let tank1 = UnitFactory.createUnit(type: .tank, at: CGPoint(x: -100, y: 0), team: .player)
        entityManager.add(tank1)

        let infantry1 = UnitFactory.createUnit(type: .infantry, at: CGPoint(x: -150, y: 50), team: .player)
        entityManager.add(infantry1)

        let artillery1 = UnitFactory.createUnit(type: .artillery, at: CGPoint(x: -150, y: -50), team: .player)
        entityManager.add(artillery1)

        // Spawn Enemy Units (Red)
        let enemyTank = UnitFactory.createUnit(type: .tank, at: CGPoint(x: 150, y: 0), team: .enemy)
        entityManager.add(enemyTank)

        let enemyInfantry = UnitFactory.createUnit(type: .infantry, at: CGPoint(x: 200, y: 50), team: .enemy)
        entityManager.add(enemyInfantry)

        // Auto-select first tank for demo
        selectEntity(tank1)

        // Add instructions label
        let label = SKLabelNode(text: "Click units to select | Click ground to move | D to damage selected unit")
        label.fontSize = 14
        label.fontColor = .white
        label.position = CGPoint(x: 0, y: frame.minY + 30)
        addChild(label)
    }

    func selectEntity(_ entity: GKEntity?) {
        // Deselect current
        if let current = selectedEntity,
           let selectable = current.component(ofType: SelectableComponent.self) {
            selectable.deselect()
        }

        // Select new
        selectedEntity = entity
        if let entity = entity,
           let selectable = entity.component(ofType: SelectableComponent.self),
           let node = entity.component(ofType: GKSKNodeComponent.self)?.node {
            selectable.select(on: node)
        }
    }

    override func touchDown(atPoint pos: CGPoint) {
        // Check if we clicked on an entity
        if let clickedEntity = entityManager.entity(at: pos) {
            // Select the entity
            selectEntity(clickedEntity)
        } else {
            // Move selected entity to position
            if let entity = selectedEntity,
               let agent = entity.component(ofType: GKAgent2D.self) {
                let targetAgent = GKAgent2D()
                targetAgent.position = vector_float2(Float(pos.x), Float(pos.y))
                agent.behavior = GKBehavior(goal: GKGoal(toSeekAgent: targetAgent), weight: 100)
            }
        }
    }

    override func keyDown(with event: NSEvent) {
        // D key - damage selected unit (for testing)
        if event.keyCode == 2 { // D key
            if let entity = selectedEntity,
               let health = entity.component(ofType: HealthComponent.self) {
                health.takeDamage(20)
            }
        }
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

    // Touch handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {}
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {}
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
}