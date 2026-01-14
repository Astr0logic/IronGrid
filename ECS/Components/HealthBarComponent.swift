import GameplayKit
import SpriteKit

class HealthBarComponent: GKComponent {
    private var backgroundBar: SKShapeNode!
    private var healthBar: SKShapeNode!
    private let barWidth: CGFloat = 40
    private let barHeight: CGFloat = 4
    private let yOffset: CGFloat = 30

    override init() {
        super.init()
        setupHealthBar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHealthBar() {
        // Background (red)
        backgroundBar = SKShapeNode(rectOf: CGSize(width: barWidth, height: barHeight))
        backgroundBar.fillColor = .red
        backgroundBar.strokeColor = .clear
        backgroundBar.position = CGPoint(x: 0, y: yOffset)
        backgroundBar.zPosition = 10

        // Health bar (green)
        healthBar = SKShapeNode(rectOf: CGSize(width: barWidth, height: barHeight))
        healthBar.fillColor = .green
        healthBar.strokeColor = .clear
        healthBar.position = CGPoint(x: 0, y: yOffset)
        healthBar.zPosition = 11
    }

    func attachTo(node: SKNode) {
        node.addChild(backgroundBar)
        node.addChild(healthBar)
    }

    func updateHealth(percentage: Float) {
        let newWidth = barWidth * CGFloat(percentage)
        let offset = (barWidth - newWidth) / 2

        healthBar.removeFromParent()
        healthBar = SKShapeNode(rectOf: CGSize(width: newWidth, height: barHeight))
        healthBar.fillColor = .green
        healthBar.strokeColor = .clear
        healthBar.position = CGPoint(x: -offset, y: yOffset)
        healthBar.zPosition = 11

        if let parent = backgroundBar.parent {
            parent.addChild(healthBar)
        }
    }
}
