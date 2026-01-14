import GameplayKit

class HealthComponent: GKComponent {
    var currentHealth: Float
    var maxHealth: Float
    var isDead: Bool { return currentHealth <= 0 }

    init(maxHealth: Float) {
        self.maxHealth = maxHealth
        self.currentHealth = maxHealth
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func takeDamage(_ damage: Float) {
        currentHealth = max(0, currentHealth - damage)
    }

    func heal(_ amount: Float) {
        currentHealth = min(maxHealth, currentHealth + amount)
    }

    func healthPercentage() -> Float {
        return currentHealth / maxHealth
    }
}
