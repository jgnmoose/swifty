//
//  Player.swift
//  swifty
//
//  Created by Jeremy Novak on 6/11/14.
//  Copyright (c) 2014 Jeremy Novak. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    let textures = GameTexturesSharedInstance
    let sounds = GameSoundsSharedInstance
    
    init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        self.setupPlayer()
    }
    
    convenience init() {
        let playerTexture = GameTexturesSharedInstance.texPlayer0
        self.init(texture: playerTexture, color: SKColor.whiteColor(), size: playerTexture.size())
    }
    
    // Player Physics and Properties
    func setupPlayer () {
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height / 2 )
        self.physicsBody.dynamic = true
        self.physicsBody.categoryBitMask = Contact.Player
        self.physicsBody.collisionBitMask = Contact.Scene
        self.physicsBody.contactTestBitMask = Contact.Object | Contact.Scene
        
        self.name = kNamePlayer
        
        self.animate()
    }
    
    // Animate Player
    func animate() {
        let animationFrames = [textures.texPlayer0, textures.texPlayer1]

        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(animationFrames, timePerFrame: 0.15)))
    }
    
    // Update Player
    func update() {
        if self.physicsBody.velocity.dy > 30.0 {
            self.zRotation = CGFloat(M_PI / 6.0)
        } else if self.physicsBody.velocity.dy < -100.0 {
            self.zRotation = CGFloat(-1 * (M_PI_4))
        } else {
            self.zRotation = 0.0
        }
    }
    
    // Fly Player
    func fly () {
        self.physicsBody.velocity = CGVectorMake(0, 0)
        self.physicsBody.applyImpulse(CGVectorMake(0, 10))
        self.runAction(sounds.flying)
    }
}
