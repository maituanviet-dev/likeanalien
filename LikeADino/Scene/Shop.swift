//
//  GameScene.swift
//  LikeADino
//
//  Created by Tuấn Việt on 04/06/2021.
//

import SpriteKit
import GameplayKit

class Shop: BaseScene {
//    var scoreLabel: SKLabelNode!
    let faded = SKTransition.fade(with: .black, duration: 1)
    var array = ["planet1", "planet2", "planet3","planet4", "planet5", "planet6"]
//    let arrayPrice = [0, 1000, 2000, 5000, 8000, 10000]
    var selectedCharacter = 0
    var ownCharacter: [Any] = ["planet1"]
    let userDefaults = UserDefaults.standard
    var image: SKSpriteNode!
//    var selectLabel: SKLabelNode!
    var characterSelected: Int!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        
        let starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: self.frame.size.width, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1.0

        
        self.ownCharacter = self.userDefaults.array(forKey: "ownCharacter") ?? ["planet1"]

        let moveRightAnimation = SKAction.move(to: CGPoint(x: 100, y: -25), duration: 0.3)
        let moveLeftAnimation = SKAction.move(to: CGPoint(x: -100, y: -25), duration: 0.3)
        let blurAnimation = SKAction.fadeAlpha(to: 0.0, duration: 0.3)
        let buttonRight = self.childNode(withName: "buttonRight") as? MSButtonNode
        let buttonLeft = self.childNode(withName: "buttonLeft") as? MSButtonNode
        let buttonBack = self.childNode(withName: "buttonBack") as? MSButtonNode
        let selectButton = self.childNode(withName: "selectButton") as? MSButtonNode
        let unlockBox = self.childNode(withName: "unlockBox") as? SKSpriteNode
        let buttonYes = unlockBox?.childNode(withName: "buttonYes") as? MSButtonNode
        let buttonNo = unlockBox?.childNode(withName: "buttonNo") as? MSButtonNode
        let currentScoreLabel = self.childNode(withName: "currentScoreLabel") as? SKLabelNode
        let gold = self.userDefaults.integer(forKey: "gold")
        let labelPlanet = self.childNode(withName: "labelPlanet") as? SKSpriteNode
        currentScoreLabel?.text = String(gold)
        
        buttonYes?.selectedHandler = {
            if(gold >= 1000) {
            self.ownCharacter.append(self.array[self.selectedCharacter])
            self.userDefaults.set(self.ownCharacter, forKey: "ownCharacter")
            self.image.removeFromParent()
            self.image = SKSpriteNode(imageNamed: self.array[self.selectedCharacter])
            self.image.size = (self.image.texture?.size())!
            self.image?.position = CGPoint(x: 0, y: -25)
            self.image.zPosition = 1.0
            self.addChild(self.image)
            unlockBox?.alpha = 0.0
                currentScoreLabel?.text = String(Int((currentScoreLabel?.text)!)! - 1000)
                self.userDefaults.set(Int((currentScoreLabel?.text)!)!, forKey: "gold")
                selectButton?.texture = SKTexture(imageNamed: "selectButton")
            } else {
                UtilManager.showAlertOK(title: "Error", message: "You don't have enough money")
                unlockBox?.alpha = 0.0
            }
        }
        
        buttonNo?.selectedHandler = {
            unlockBox?.alpha = 0.0
        }
        
        selectButton?.selectedHandler = {
            let imageName = self.array[self.selectedCharacter]
            
            if !self.ownCharacter.contains(where: { $0 as! String == imageName }) {
                unlockBox?.alpha = 1.0
            } else {
            guard let skView = self.view else {
                print("Could not get Skview")
                return
            }
            let scene = GameScene(fileNamed: "GameScene")!
            scene.character = self.selectedCharacter + 1
            scene.scaleMode = .aspectFill
            skView.presentScene(scene, transition: self.faded)
            }
        }
        
        buttonBack?.selectedHandler = {
            guard let skView = self.view else {
                print("Could not get Skview")
                return
            }
            let scene = Home(fileNamed: "Home")!
            scene.scaleMode = .aspectFill
            skView.presentScene(scene, transition: self.faded)
        }
        
        
        image = self.childNode(withName: "image") as? SKSpriteNode

        buttonLeft?.selectedHandler = {
                    self.image?.run(SKAction.group([moveRightAnimation, blurAnimation])) {
                        self.image?.removeFromParent()
                        if (self.selectedCharacter == (self.array.count - 1)) {
                            self.selectedCharacter = 0
                        } else {
                            self.selectedCharacter += 1
                        }
                        var imageName = self.array[self.selectedCharacter]
                        
                        if !self.ownCharacter.contains(where: { $0 as! String == imageName }) {
                            imageName = "inactive\(imageName)"
                            selectButton?.texture = SKTexture(imageNamed: "unlockButton")
                        } else {
                            selectButton?.texture = SKTexture(imageNamed: "selectButton")
                        }

                        self.image = SKSpriteNode(imageNamed: imageName)
                        self.image?.position = CGPoint(x: -100, y: -25)
                        self.addImage(node: self.image!)
                        labelPlanet?.texture = SKTexture(imageNamed: "label\(self.selectedCharacter + 1)")
                        labelPlanet?.size = (labelPlanet?.texture?.size())!
                    }
                }
        
                buttonRight?.selectedHandler = {
                    self.image?.run(SKAction.group([moveLeftAnimation, blurAnimation])) {
                        self.image?.removeFromParent()
                        if (self.selectedCharacter == 0) {
                            self.selectedCharacter = (self.array.count - 1)
                        } else {
                            self.selectedCharacter -= 1
                        }
                        var imageName = self.array[self.selectedCharacter]
                        
                        if !self.ownCharacter.contains(where: { $0 as! String == imageName }) {
                            imageName = "inactive\(imageName)"
                            selectButton?.texture = SKTexture(imageNamed: "unlockButton")
                        } else {
                            selectButton?.texture = SKTexture(imageNamed: "selectButton")
                        }
                        self.image = SKSpriteNode(imageNamed: imageName)
                        self.image?.position = CGPoint(x: 100, y: -25)
                        self.addImage(node: self.image!)
                        labelPlanet?.texture = SKTexture(imageNamed: "label\(self.selectedCharacter + 1)")
                        labelPlanet?.size = (labelPlanet?.texture?.size())!
                    }
                }
    }
    func addImage(node: SKNode) {
        let displayAnimation = SKAction.fadeAlpha(to: 1.0, duration: 0.3)
        let moveCenterAnimation = SKAction.move(to: CGPoint(x: 0, y: -25), duration: 0.3)
        node.zPosition = 1.0
        node.alpha = 0.0
        self.addChild(node)
        node.run(SKAction.group([displayAnimation, moveCenterAnimation]))
    }
}
