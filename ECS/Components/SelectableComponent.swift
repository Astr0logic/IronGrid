import GameplayKit
import SpriteKit

class SelectableComponent: GKComponent {
    var isSelected: Bool = false
    var selectionRing: SKShapeNode?

    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func select(on node: SKNode) {
        isSelected = true

        // Create selection ring if it doesn't exist
        if selectionRing == nil {
            selectionRing = SKShapeNode(circleOfRadius: 25)
            selectionRing!.strokeColor = .yellow
            selectionRing!.lineWidth = 2
            selectionRing!.fillColor = .clear
            selectionRing!.zPosition = -1
            node.addChild(selectionRing!)
        }
        selectionRing?.isHidden = false
    }

    func deselect() {
        isSelected = false
        selectionRing?.isHidden = true
    }
}
