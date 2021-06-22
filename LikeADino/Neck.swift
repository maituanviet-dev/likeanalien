import Foundation
import SpriteKit

class Neck: SKSpriteNode {
    init(character: Int) {
        let texture = SKTexture(imageNamed: "neck\(character)")
        super.init(texture: texture, color: .clear, size: CGSize(width: 16, height: 24))
        zPosition = 1.0
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 16, height: 24))
        physicsBody?.affectedByGravity = false
        physicsBody?.density = 1
        physicsBody?.categoryBitMask = 1
        physicsBody?.allowsRotation = false

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
