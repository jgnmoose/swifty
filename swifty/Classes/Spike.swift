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
        let randomY = CGFloat(arc4random()) % CGFloat(viewSize.height / 3)
        
        // Top and Bottom Spikes
        let bottomSpike = SKSpriteNode(texture: textures.texSpikeBottom)
        bottomSpike.name = kNameSpikeBottom
        let topSpike = SKSpriteNode(texture: textures.texSpikeTop)
        topSpike.name = kNameSpikeTop
        
        bottomSpike.position = CGPoint(x: 0, y: randomY)
        topSpike.position = CGPoint(x: bottomSpike.position.x, y: randomY + bottomSpike.size.height + spikeGap)
        
        // Bottom Spike shape and Physics
        let bottomSpikeOffsetX = bottomSpike.frame.size.width * bottomSpike.anchorPoint.x
        let bottomSpikeOffsetY = bottomSpike.frame.size.height * bottomSpike.anchorPoint.y
        
        let bottomSpikePath = CGPathCreateMutable()
        
        CGPathMoveToPoint(bottomSpikePath, nil, 101 - bottomSpikeOffsetX, 267 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(bottomSpikePath, nil, 98 - bottomSpikeOffsetX, 1 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(bottomSpikePath, nil, 29 - bottomSpikeOffsetX, 1 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(bottomSpikePath, nil, 26 - bottomSpikeOffsetX, 24 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(bottomSpikePath, nil, 0 - bottomSpikeOffsetX, 52 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(bottomSpikePath, nil, 28 - bottomSpikeOffsetX, 59 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(bottomSpikePath, nil, 28 - bottomSpikeOffsetX, 93 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(bottomSpikePath, nil, 3 - bottomSpikeOffsetX, 119 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(bottomSpikePath, nil, 33 - bottomSpikeOffsetX, 124 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(bottomSpikePath, nil, 35 - bottomSpikeOffsetX, 156 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(bottomSpikePath, nil, 12 - bottomSpikeOffsetX, 178 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(bottomSpikePath, nil, 38 - bottomSpikeOffsetX, 182 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(bottomSpikePath, nil, 37 - bottomSpikeOffsetX, 217 - bottomSpikeOffsetY)
        
        CGPathCloseSubpath(bottomSpikePath)
        bottomSpike.physicsBody = SKPhysicsBody(polygonFromPath: bottomSpikePath)
        bottomSpike.physicsBody.dynamic = false
        bottomSpike.physicsBody.categoryBitMask = Contact.Object
        bottomSpike.physicsBody.contactTestBitMask = Contact.Player
        CGPathRelease(bottomSpikePath)
        
        // Top Spike shape and Physics
        let topSpikeOffsetX = topSpike.frame.size.width * topSpike.anchorPoint.x
        let topSpikeOffsetY = topSpike.frame.size.height * topSpike.anchorPoint.y
        
        let topSpikePath = CGPathCreateMutable()
        
        CGPathMoveToPoint(topSpikePath, nil, 99 - topSpikeOffsetX, 269 - topSpikeOffsetY);
        CGPathAddLineToPoint(topSpikePath, nil, 103 - topSpikeOffsetX, 2 - topSpikeOffsetY);
        CGPathAddLineToPoint(topSpikePath, nil, 36 - topSpikeOffsetX, 55 - topSpikeOffsetY);
        CGPathAddLineToPoint(topSpikePath, nil, 37 - topSpikeOffsetX, 88 - topSpikeOffsetY);
        CGPathAddLineToPoint(topSpikePath, nil, 12 - topSpikeOffsetX, 97 - topSpikeOffsetY);
        CGPathAddLineToPoint(topSpikePath, nil, 34 - topSpikeOffsetX, 115 - topSpikeOffsetY);
        CGPathAddLineToPoint(topSpikePath, nil, 33 - topSpikeOffsetX, 145 - topSpikeOffsetY);
        CGPathAddLineToPoint(topSpikePath, nil, 2 - topSpikeOffsetX, 154 - topSpikeOffsetY);
        CGPathAddLineToPoint(topSpikePath, nil, 29 - topSpikeOffsetX, 175 - topSpikeOffsetY);
        CGPathAddLineToPoint(topSpikePath, nil, 30 - topSpikeOffsetX, 211 - topSpikeOffsetY);
        CGPathAddLineToPoint(topSpikePath, nil, 1 - topSpikeOffsetX, 214 - topSpikeOffsetY);
        CGPathAddLineToPoint(topSpikePath, nil, 27 - topSpikeOffsetX, 244 - topSpikeOffsetY);
        CGPathAddLineToPoint(topSpikePath, nil, 29 - topSpikeOffsetX, 272 - topSpikeOffsetY);
        
        CGPathCloseSubpath(topSpikePath)
        topSpike.physicsBody = SKPhysicsBody(polygonFromPath: topSpikePath)
        topSpike.physicsBody.dynamic = false
        topSpike.physicsBody.categoryBitMask = Contact.Object
        topSpike.physicsBody.contactTestBitMask = Contact.Player
        CGPathRelease(topSpikePath)
        
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

