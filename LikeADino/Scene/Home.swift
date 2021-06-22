//
//  GameScene.swift
//  LikeADino
//
//  Created by Tuấn Việt on 04/06/2021.
//

import SpriteKit
import GameplayKit

class Home: BaseScene {
    let faded = SKTransition.fade(with: .black, duration: 1)
    let userDefaults = UserDefaults.standard

    override func didMove(to view: SKView) {
        super.enableBanner = true
        super.didMove(to: view)
        
        let starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: self.frame.size.width, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = 0
        
        let start = self.childNode(withName: "start") as! MSButtonNode
        let wheel = self.childNode(withName: "wheelButton") as! MSButtonNode
        
        wheel.selectedHandler = {
            guard let skView = self.view else {
                print("Could not get Skview")
                return
            }
            let scene = Wheel(fileNamed: "Wheel")!
            scene.scaleMode = .aspectFill
            skView.presentScene(scene, transition: self.faded)
        }
        
        start.selectedHandler = {
            guard let skView = self.view else {
                print("Could not get Skview")
                return
            }
                    let scene = Shop(fileNamed: "Shop")!
                    scene.scaleMode = .aspectFill
                    skView.presentScene(scene, transition: self.faded)
            }
        }
        
    override func update(_ currentTime: TimeInterval) {
    }
}
