//
//  Wheel.swift
//  LikeADino
//
//  Created by Tuấn Việt on 19/06/2021.
//

import Foundation
import SpriteKit
import GameplayKit

class Wheel: BaseScene {
    let faded = SKTransition.fade(with: .black, duration: 1)
    let userDefaults = UserDefaults.standard
    var currenDot: SKSpriteNode?
    var loading:Bool = false
    override func didMove(to view: SKView) {
        super.enableBanner = true
        super.didMove(to: view)
        let rotationAction = SKAction.rotate(byAngle: -CGFloat.pi * 2, duration: 3.0)
        let starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: self.frame.size.width, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = 0
        
        let wheel = self.childNode(withName: "wheel") as! SKSpriteNode
        let rollButton = self.childNode(withName: "rollButton") as! MSButtonNode
        let scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        let buttonBack = self.childNode(withName: "buttonBack") as! MSButtonNode
        let gold = self.userDefaults.integer(forKey: "gold")
        var turn = self.userDefaults.integer(forKey: "turn")
        let currentScoreLabel = self.childNode(withName: "currentScoreLabel") as! SKLabelNode
        let turnLabel = self.childNode(withName: "turnLabel") as! SKLabelNode
        let adsLabel = self.childNode(withName: "adsLabel") as! SKLabelNode
        
        turnLabel.text = "You Have \(turn) turns"
        if(turn == 0) {
            adsLabel.alpha = 1.0
            rollButton.texture = SKTexture(imageNamed: "yesButton")
        }
        currentScoreLabel.text = String(gold)

        buttonBack.selectedHandler = {
            guard let skView = self.view else {
                print("Could not get Skview")
                return
            }
            let scene = Home(fileNamed: "Home")!
            scene.scaleMode = .aspectFill
            skView.presentScene(scene, transition: self.faded)
        }
        
        var arrayDot: [SKSpriteNode] = []
        
        arrayDot.append(wheel.childNode(withName: "dot1") as! SKSpriteNode)
        arrayDot.append(wheel.childNode(withName: "dot2") as! SKSpriteNode)
        arrayDot.append(wheel.childNode(withName: "dot3") as! SKSpriteNode)
        arrayDot.append(wheel.childNode(withName: "dot4") as! SKSpriteNode)
        arrayDot.append(wheel.childNode(withName: "dot5") as! SKSpriteNode)
        arrayDot.append(wheel.childNode(withName: "dot6") as! SKSpriteNode)
        arrayDot.append(wheel.childNode(withName: "dot7") as! SKSpriteNode)
        arrayDot.append(wheel.childNode(withName: "dot8") as! SKSpriteNode)
            
        
        rollButton.selectedHandler = {
            if(turn > 0) {
            if (!self.loading) {
            self.loading = true
            if let currentDot = self.currenDot {
                currentDot.alpha = 0.0
            }
            wheel.run(rotationAction) {
                self.currenDot = arrayDot.shuffled().first
                self.currenDot?.alpha = 1.0
                scoreLabel.text = String(self.wheelScore(name: (self.currenDot?.name)!))
                currentScoreLabel.text = String( Int(currentScoreLabel.text!)! + self.wheelScore(name: (self.currenDot?.name)!))
                self.userDefaults.set(Int(currentScoreLabel.text!), forKey: "gold")
                turn -= 1
                turnLabel.text = "You Have \(turn) turns"
                self.userDefaults.set(turn, forKey: "turn")
                if (turn == 0) {
                rollButton.texture = SKTexture(imageNamed: "yesButton")
                }
                self.loading = false
            }
            } else {
                turn += 1
                turnLabel.text = "You Have \(turn) turns"
                self.userDefaults.set(turn, forKey: "turn")
                if (turn > 0) {
                rollButton.texture = SKTexture(imageNamed: "rollButton")
                }
            }
        }
    }
    }
    override func update(_ currentTime: TimeInterval) {
    }
    
    func wheelScore(name: String)-> Int {
        switch name {
        case "dot1":
            return 100
        case "dot2":
            return 1000
        case "dot3":
            return 200
        case "dot4":
            return 100
        case "dot5":
            return 200
        case "dot6":
            return 700
        case "dot7":
            return 100
        case "dot8":
            return 200
        default:
            return 100
        }
    }
}
