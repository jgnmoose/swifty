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
    
    init() {
        textureAtlas = SKTextureAtlas(named: "artwork")
    }
}
