import GameplayKit
import SpriteKit

enum Team: Int {
    case player = 0
    case enemy = 1
    case neutral = 2

    var color: SKColor {
        switch self {
        case .player: return .green
        case .enemy: return .red
        case .neutral: return .gray
        }
    }

    func isHostileTo(_ other: Team) -> Bool {
        if self == .neutral || other == .neutral {
            return false
        }
        return self != other
    }
}

class TeamComponent: GKComponent {
    var team: Team

    init(team: Team) {
        self.team = team
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
