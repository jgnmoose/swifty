//
//  GameTextures.swift
//  swifty
//
//  Created by Jeremy Novak on 7/9/14.
//  Copyright (c) 2014 Jeremy Novak. All rights reserved.
//

import SpriteKit

let GameTexturesSharedInstance = GameTextures ()

class GameTextures {
    
    class var sharedInstance:GameTextures {
        return GameTexturesSharedInstance
    }
    
    var textureAtlas = SKTextureAtlas()
    let texCityBack = SKTexture(imageNamed: "city-back")
    let texCityFront = SKTexture(imageNamed: "city-front")
    let texGround = SKTexture(imageNamed: "ground")
    let texPlayer0 = SKTexture(imageNamed: "player0")
    let texPlayer1 = SKTexture(imageNamed: "player1")
    let texSpikeBottom = SKTexture(imageNamed: "spikebottom")
    let texSpikeTop = SKTexture(imageNamed: "spiketop")
    let texMoon = SKTexture(imageNamed: "moon")
    
    var pathBottomSpike:CGMutablePathRef!
    var pathTopSpike:CGMutablePathRef!

    
    init() {
        textureAtlas = SKTextureAtlas(named: "artwork")
        self.createCGPathRefs()
    }
    
    func createCGPathRefs() {
        // Bottom Spike CGMutablePathRef
        let bottomSpikeOffsetX = texSpikeBottom.size().width * 0.5
        let bottomSpikeOffsetY = texSpikeBottom.size().height * 0.5
        
        pathBottomSpike = CGPathCreateMutable()
        CGPathMoveToPoint(pathBottomSpike, nil, 101 - bottomSpikeOffsetX, 267 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(pathBottomSpike, nil, 98 - bottomSpikeOffsetX, 1 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(pathBottomSpike, nil, 29 - bottomSpikeOffsetX, 1 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(pathBottomSpike, nil, 26 - bottomSpikeOffsetX, 24 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(pathBottomSpike, nil, 0 - bottomSpikeOffsetX, 52 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(pathBottomSpike, nil, 28 - bottomSpikeOffsetX, 59 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(pathBottomSpike, nil, 28 - bottomSpikeOffsetX, 93 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(pathBottomSpike, nil, 3 - bottomSpikeOffsetX, 119 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(pathBottomSpike, nil, 33 - bottomSpikeOffsetX, 124 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(pathBottomSpike, nil, 35 - bottomSpikeOffsetX, 156 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(pathBottomSpike, nil, 12 - bottomSpikeOffsetX, 178 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(pathBottomSpike, nil, 38 - bottomSpikeOffsetX, 182 - bottomSpikeOffsetY)
        CGPathAddLineToPoint(pathBottomSpike, nil, 37 - bottomSpikeOffsetX, 217 - bottomSpikeOffsetY)
        CGPathCloseSubpath(pathBottomSpike)
        
        // Top Spike CGMutablePathRef
        let topSpikeOffsetX = texSpikeTop.size().width * 0.5
        let topSpikeOffsetY = texSpikeTop.size().height * 0.5
        
        pathTopSpike = CGPathCreateMutable()
        CGPathMoveToPoint(pathTopSpike, nil, 99 - topSpikeOffsetX, 269 - topSpikeOffsetY);
        CGPathAddLineToPoint(pathTopSpike, nil, 103 - topSpikeOffsetX, 2 - topSpikeOffsetY);
        CGPathAddLineToPoint(pathTopSpike, nil, 36 - topSpikeOffsetX, 55 - topSpikeOffsetY);
        CGPathAddLineToPoint(pathTopSpike, nil, 37 - topSpikeOffsetX, 88 - topSpikeOffsetY);
        CGPathAddLineToPoint(pathTopSpike, nil, 12 - topSpikeOffsetX, 97 - topSpikeOffsetY);
        CGPathAddLineToPoint(pathTopSpike, nil, 34 - topSpikeOffsetX, 115 - topSpikeOffsetY);
        CGPathAddLineToPoint(pathTopSpike, nil, 33 - topSpikeOffsetX, 145 - topSpikeOffsetY);
        CGPathAddLineToPoint(pathTopSpike, nil, 2 - topSpikeOffsetX, 154 - topSpikeOffsetY);
        CGPathAddLineToPoint(pathTopSpike, nil, 29 - topSpikeOffsetX, 175 - topSpikeOffsetY);
        CGPathAddLineToPoint(pathTopSpike, nil, 30 - topSpikeOffsetX, 211 - topSpikeOffsetY);
        CGPathAddLineToPoint(pathTopSpike, nil, 1 - topSpikeOffsetX, 214 - topSpikeOffsetY);
        CGPathAddLineToPoint(pathTopSpike, nil, 27 - topSpikeOffsetX, 244 - topSpikeOffsetY);
        CGPathAddLineToPoint(pathTopSpike, nil, 29 - topSpikeOffsetX, 272 - topSpikeOffsetY);
        CGPathCloseSubpath(pathTopSpike)
    }
}
