//
//  Player.swift
//  swifty
//
//  Created by Jeremy Novak on 6/11/14.
//  Copyright (c) 2014 Jeremy Novak. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    // Init Player
    init(imageNamed name: String!) {
        super.init(imageNamed: name)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height / 2 )
        self.physicsBody.dynamic = true
        
        self.animate()
    }
    
    init(texture: SKTexture!) {
        super.init(texture: texture)
    }
    
    init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    // Animate Player
    func animate() {
        let animationFrames = [
            SKTexture(imageNamed: "player0"),
            SKTexture(imageNamed: "player1")
        ]
        
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(animationFrames, timePerFrame: 0.15)))
    }
    
    // Update Player
    func update() {
        if self.physicsBody.velocity.dy > 30.0 {
            self.zRotation = 3.14 / 6.0
        } else if self.physicsBody.velocity.dy < -100.0 {
            self.zRotation = -1 * (3.14 / 4.0)
        } else {
            self.zRotation = 0.0
        }
    }
    
    // Fly Player
    func fly () {
        self.physicsBody.velocity = CGVectorMake(0, 0)
        self.physicsBody.applyImpulse(CGVectorMake(0, 60))
        self.runAction(SKAction.playSoundFileNamed(kSoundFly, waitForCompletion: false))
    }
}
