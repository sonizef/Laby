//
//  GameScene.swift
//  Laby
//
//  Created by Joris ZEFIRINI on 27/10/2017.
//  Copyright © 2017 SoniWeb. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var balle = SKSpriteNode()
    var haut = SKSpriteNode()
    var bas = SKSpriteNode()
    
    var isBallTouched = false
    
    let category1: UInt32 = 0x1 << 1
    let category2: UInt32 = 0x1 << 2
    
    
    let motionManager = CMMotionManager()
    
    override func sceneDidLoad() {
        physicsWorld.contactDelegate = self
        motionManager.startAccelerometerUpdates()
        haut = childNode(withName: "haut") as! SKSpriteNode
        bas = childNode(withName: "bas") as! SKSpriteNode
        balle = self.childNode(withName: "balle") as! SKSpriteNode
        
        balle.physicsBody?.categoryBitMask = category1
        balle.physicsBody?.contactTestBitMask = category2
        balle.physicsBody?.collisionBitMask = category2
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if(motionManager.accelerometerData?.acceleration.x != nil){
            
            balle.position.x += (motionManager.accelerometerData?.acceleration.x.roundedCG(toPlaces: 2))!*20
            balle.position.y += (motionManager.accelerometerData?.acceleration.y.roundedCG(toPlaces: 2))!*20
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        isBallTouched = false
        
        if(contact.bodyB.node?.name == "balle" || contact.bodyA.node?.name == "balle"){

            let lbl = SKLabelNode(text: "BOOM")
            lbl.position = contact.contactPoint
            lbl.alpha = 0
            lbl.setScale(0.6)
        
            
            self.addChild(lbl)
            
            lbl.run(SKAction.scale(to: 1.5, duration: 1.0))
            lbl.run(SKAction.sequence([SKAction.fadeIn(withDuration: 0.25),
                                       SKAction.wait(forDuration: 0.25),
                                       SKAction.fadeOut(withDuration: 0.5)]))
            
        }
        else{
            print("Contacte entre \(String(describing: contact.bodyA.node?.name)) et \(String(describing: contact.bodyB.node?.name))")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        balle.color = UIColor.green
        
        for t in touches{
            let location = t.location(in: self)
            let node : SKNode = self.atPoint(location)
            if node.name == "haut" {
                balle.position.y = balle.position.y + 20
            }
            else if node.name == "bas"{
                balle.position.y = balle.position.y - 20
            }
            else if node.name == "balle"{
                isBallTouched = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            
            if(isBallTouched){
                balle.position.x = t.location(in: self).x
                balle.position.y = t.location(in: self).y
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isBallTouched = false
    }

}
