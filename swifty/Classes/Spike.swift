//
//  Spike.swift
//  swifty
//
//  Created by Jeremy Novak on 7/9/14.
//  Copyright (c) 2014 Jeremy Novak. All rights reserved.
//

import SpriteKit

class Spike {
    
    let textures = GameTexturesSharedInstance
    
    func creatSpikes() -> SKNode {
        let spikeGap:CGFloat = 100.0
        
        // Parent node for the spikes and score node
        let pair = SKNode()
        pair.position = CGPoint(x: viewSize.width + textures.texSpikeBottom.size().width, y: 0)
        pair.zPosition = GameLayer.Spikes
        
        // Random Y position on screen
        let randomY = CGFloat(Int(arc4random_uniform(UInt32(UInt(viewSize.height / 3)))))
        
        // Top and Bottom Spikes
        let bottomSpike = SKSpriteNode(texture: textures.texSpikeBottom)
        bottomSpike.name = kNameSpikeBottom
        let topSpike = SKSpriteNode(texture: textures.texSpikeTop)
        topSpike.name = kNameSpikeTop
        
        bottomSpike.position = CGPoint(x: 0, y: randomY)
        topSpike.position = CGPoint(x: bottomSpike.position.x, y: randomY + bottomSpike.size.height + spikeGap)
        
        // Bottom Spike Physics
        bottomSpike.physicsBody = SKPhysicsBody(polygonFromPath: textures.pathBottomSpike)
        bottomSpike.physicsBody.dynamic = false
        bottomSpike.physicsBody.categoryBitMask = Contact.Object
        bottomSpike.physicsBody.contactTestBitMask = Contact.Player
        
        // Top Spike Physics
        topSpike.physicsBody = SKPhysicsBody(polygonFromPath: textures.pathTopSpike)
        topSpike.physicsBody.dynamic = false
        topSpike.physicsBody.categoryBitMask = Contact.Object
        topSpike.physicsBody.contactTestBitMask = Contact.Player
        
        // Score Node
        let scoreNode = SKNode()
        scoreNode.position = CGPoint(x: bottomSpike.size.width, y: viewSize.height / 2)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(bottomSpike.size.width / 2, viewSize.height))
        scoreNode.physicsBody.dynamic = false
        scoreNode.physicsBody.categoryBitMask = Contact.Score
        scoreNode.physicsBody.contactTestBitMask = Contact.Player
        
        // Add the spikes and score node to the pair node
        pair.addChild(bottomSpike)
        pair.addChild(topSpike)
        pair.addChild(scoreNode)
        
        // Movement Action
        let move = SKAction.moveToX(-viewSize.width, duration: 3.0)
        let remove = SKAction.removeFromParent()
        let moveSequence = SKAction.sequence([move, remove])
        
        pair.runAction(moveSequence, withKey: kNameSpikeSpawn)
        
        return pair
    }
}

