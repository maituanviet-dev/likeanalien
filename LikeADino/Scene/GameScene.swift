//
//  GameScene.swift
//  LikeADino
//
//  Created by Tuấn Việt on 04/06/2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var character: Int = 1
    var player: SKSpriteNode!
    var head: SKSpriteNode!
    var body: SKSpriteNode!
    var lastXTouch:CGFloat = -1
    var currentPoint: CGPoint = CGPoint(x: 0, y: -35)
    var inverter: Bool = false
    var neckArray: [Neck] = []
    var scoreLabel: SKLabelNode!
    var goScoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "\(score)"
            goScoreLabel.text = "\(score)"
        }
    }
    var isGameOver: Bool = false
    var starfield: SKEmitterNode!
    var separator: SKSpriteNode!
    let faded = SKTransition.fade(with: .black, duration: 1)
    let userDefaults = UserDefaults.standard
    var realPaused: Bool = false {
        didSet {
            self.isPaused = realPaused
        }
    }
    var backgroundBlur: SKSpriteNode!
    var gameoverBox: SKSpriteNode!
    var bestScoreLabel: SKLabelNode!
    var resumeBox: SKSpriteNode!
    var speedGame: CGFloat = 2.0

    override func didMove(to view: SKView) {
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -2.0)

        
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { timer in
            self.speedGame = self.speedGame - (self.speedGame * 10 / 100)
        }
        
        
        //resume
        resumeBox = self.childNode(withName: "resumeBox") as? SKSpriteNode
        let resumeButton = resumeBox.childNode(withName: "resumeButton") as? MSButtonNode
        let backToHome = resumeBox.childNode(withName: "backToHome") as? MSButtonNode

        backToHome?.selectedHandler = {
            guard let skView = self.view else {
                print("Could not get Skview")
                return
            }
            let scene = Home(fileNamed: "Home")!
            scene.scaleMode = .aspectFill
            skView.presentScene(scene, transition: self.faded)
        }
        
        resumeButton?.selectedHandler = {
            self.resumeBox.alpha = 0.0
            self.backgroundBlur.alpha = 0.0
            self.realPaused = false
        }
        
        //go
        backgroundBlur = self.childNode(withName: "backgroundBlur") as? SKSpriteNode
        gameoverBox = self.childNode(withName: "gameoverBox") as? SKSpriteNode
        let backButton = gameoverBox?.childNode(withName: "backButton") as? MSButtonNode
        let tryAgainButton = gameoverBox?.childNode(withName: "tryAgainButton") as? MSButtonNode
        goScoreLabel = gameoverBox?.childNode(withName: "goScoreLabel") as? SKLabelNode
        bestScoreLabel = gameoverBox?.childNode(withName: "bestScoreLabel") as? SKLabelNode
        bestScoreLabel!.text =  String(self.userDefaults.integer(forKey: "bestScore"))

        run(.repeatForever(.sequence([
            .wait(forDuration: Double.random(in: 15.0...30.0)),
            .run { [weak self] in
                self?.createUfo()
            }
        ])))
        
        backButton?.selectedHandler = {
            guard let skView = self.view else {
                print("Could not get Skview")
                return
            }
            let scene = Home(fileNamed: "Home")!
            scene.scaleMode = .aspectFill
            skView.presentScene(scene, transition: self.faded)
        }
        
        tryAgainButton?.selectedHandler = {
            guard let skView = self.view else {
                print("Could not get Skview")
                return
            }
            let scene = GameScene(fileNamed: "GameScene")!
            scene.character = self.character
            scene.scaleMode = .aspectFill
            skView.presentScene(scene, transition: self.faded)
        }
        
        //bg
        delayWithSeconds(2.0) {
         self.addChild(SKAudioNode(fileNamed: "backgroundSong.mp3"))
        }
         starfield = SKEmitterNode(fileNamed: "starfield")!
         starfield.position = CGPoint(x: self.frame.size.width, y: 384)
         starfield.advanceSimulationTime(10)
         addChild(starfield)
         starfield.zPosition = 0
         
        separator = self.childNode(withName: "separator") as? SKSpriteNode
        
        let ground = self.childNode(withName: "ground") as? SKSpriteNode
        if(character != 1) {
        ground?.texture = SKTexture(imageNamed: "ground\(character)")
        ground?.size = (ground?.texture?.size())!
        }
        //config separator
        separator.physicsBody = SKPhysicsBody(rectangleOf: separator.size)
        separator.physicsBody?.affectedByGravity = false
        separator.physicsBody?.density = 1000000
        separator.physicsBody?.contactTestBitMask = 1
        
        scoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode
        
        player = self.childNode(withName: "player") as? SKSpriteNode
        player.texture = SKTexture(imageNamed: "neck\(String(describing: character))")
        //body config
        body = player.childNode(withName: "body") as? SKSpriteNode
        body.texture = SKTexture(imageNamed: "body\(String(describing: character))")
        body.size = (body.texture?.size())!

        // head config
        head = player.childNode(withName: "head") as? SKSpriteNode
        head.texture = SKTexture(imageNamed: "head\(String(describing: character))")
        head.size = (head.texture?.size())!
        head.physicsBody = SKPhysicsBody(texture: head.texture!, size: head.size)
        head.physicsBody?.affectedByGravity = false
        head.physicsBody?.density = 1000000
        head.physicsBody?.contactTestBitMask = 1

//        physicsWorld.gravity = CGVector(dx: 0, dy: -1.8)
        physicsWorld.contactDelegate = self
//.
      let pauseButton = self.childNode(withName: "pauseButton") as? MSButtonNode
        pauseButton?.selectedHandler = {
            self.realPaused = true
            self.resumeBox.alpha = 1.0
            self.backgroundBlur.alpha = 1.0
        }
        
//         run action
        run(.repeatForever(.sequence([
            .wait(forDuration:  0.416),
             .run { [weak self] in
                self?.createANeck()
             }
         ])))
    }
    
    func runUfo() {
        let ufo = SKSpriteNode(imageNamed: "ufo")
        ufo.name = "ufoRun"
        ufo.physicsBody = SKPhysicsBody(texture: ufo.texture!, size: ufo.size)
        ufo.physicsBody?.affectedByGravity = false
        ufo.physicsBody?.density = 10000
        ufo.position = CGPoint(x: 0, y: 100)
        ufo.physicsBody?.contactTestBitMask = 1

        addChild(ufo)
        let action = SKAction.move(to: CGPoint(x: Int.random(in: -150...150), y: Int.random(in: 0...300)), duration: 2.0)
        let actionSmall = SKAction.scale(by: 0.0, duration: 1.0)

        ufo.run(action) {
            let action2 = SKAction.move(to: CGPoint(x: Int.random(in: -150...150), y: Int.random(in: 0...300)), duration: 2.0)
            ufo.run(action2) {
                let action3 = SKAction.move(to: CGPoint(x: Int.random(in: -150...150), y: Int.random(in: 0...300)), duration: 2.0)
                ufo.run(action3) {
                    let action4 = SKAction.move(to: CGPoint(x: Int.random(in: -150...150), y: Int.random(in: 0...300)), duration: 2.0)
                    ufo.run(action4) {
                        ufo.run(actionSmall)
                    }
                }
            }
        }
    }
    
    func emit() {
        let explosion = SKEmitterNode(fileNamed: "emit")!
        explosion.position = player.position
        addChild(explosion)
    }
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "separator" && contact.bodyB.node?.name == "neck") {
            self.gameover()
            return
        }
        if (contact.bodyA.node?.name == "head" && contact.bodyB.node?.name == "ufo") {
            self.runUfo()
            contact.bodyB.node?.removeFromParent()
            self.emit()
            return
        }
        
        if (contact.bodyA.node?.name == "neck" && contact.bodyB.node?.name == "ufoRun" || contact.bodyB.node?.name == "neck" && contact.bodyA.node?.name == "ufoRun") {
            
            if (contact.bodyA.node?.name == "neck") {
                contact.bodyA.node?.removeFromParent()
            } else if(contact.bodyB.node?.name == "neck"){
                contact.bodyB.node?.removeFromParent()
            }
            return
        }
        
        if (contact.bodyA.node?.name == "neck" && contact.bodyB.node?.name == "ufo" || contact.bodyB.node?.name == "neck" && contact.bodyA.node?.name == "ufo") {
            
            if (contact.bodyA.node?.name == "neck") {
                contact.bodyA.node?.removeFromParent()
            } else if(contact.bodyB.node?.name == "neck"){
                contact.bodyB.node?.removeFromParent()
            }
            self.emit()
            return
        }
         
            body.position.y -= 20.0
        //add neck
        let neckMore = SKSpriteNode(imageNamed: "neck\(character)")
        neckMore.name = "neckMore"
        neckMore.size = CGSize(width: neckMore.frame.width, height: neckMore.frame.height)
        neckMore.anchorPoint = CGPoint(x: 0.5, y: 0)
        neckMore.position = currentPoint
        neckMore.xScale = !inverter ? -1.0 : 1.0
        neckMore.zPosition = 1.0

        // config
        currentPoint.y -= 20.0
        inverter = !inverter
        player.addChild(neckMore)
        score += 1
        contact.bodyB.node?.removeFromParent()
        self.emit()
        //remove neck
        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    func createUfo() {
        let rotationAction = SKAction.rotate(byAngle: -CGFloat.pi * 5, duration: 5.0)
        let ufo = SKSpriteNode(imageNamed: "ufo")
        ufo.name = "ufo"
        ufo.physicsBody = SKPhysicsBody(texture: ufo.texture!, size: ufo.size)
        ufo.physicsBody?.affectedByGravity = true
        ufo.physicsBody?.density = 1000
        let randomX =  Double.random(in: -135.0...135.0)
        ufo.position = CGPoint(x: randomX, y: Double(self.frame.height))
        addChild(ufo)
        ufo.run(rotationAction)
        
    }
    
    func gameover() {
        self.isGameOver = true
        self.realPaused = true
        self.backgroundBlur.alpha = 1.0
        self.gameoverBox.alpha = 1.0
        self.userDefaults.set(score + self.userDefaults.integer(forKey: "gold"), forKey: "gold")
        if(score >= self.userDefaults.integer(forKey: "bestScore")) {
        self.bestScoreLabel!.text = String(self.score)
        self.userDefaults.set(score, forKey: "bestScore")
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if (self.realPaused) { return }
        let location = touch.location(in: self)

        if lastXTouch > location.x + 5 {
            if (player.xScale > 0.0) {
                player.xScale *= -1.0
            }
        } else if(lastXTouch < location.x - 5) {
            if (player.xScale < 0.0) {
                player.xScale *= -1.0
            }
        }
        
        if(location.x > -120 && location.x < 120) {
        player.position.x = location.x
        lastXTouch = location.x
        } else if(location.x < -120) {
            player.position.x = -120
            lastXTouch = location.x
        } else if(location.x > 120) {
            player.position.x = 120
            lastXTouch = location.x
        }
    }
    
    
    func createANeck() {
        let moveTo = SKAction.moveTo(y: self.separator.position.y, duration: TimeInterval(speedGame))
        let randomX =  Double.random(in: -135.0...135.0)
        let neck = Neck(character: character);
        neck.name = "neck"
        neck.position = CGPoint(x: randomX, y: Double(self.frame.height))
        addChild(neck)
        neck.run(moveTo)
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }

    override func update(_ currentTime: TimeInterval) {
    }
}
