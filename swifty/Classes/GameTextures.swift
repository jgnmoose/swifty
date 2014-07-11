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
    
    var textureAtlas = SKTextureAtlas()
    var texCityBack = SKTexture(imageNamed: "city-back")
    var texCityFront = SKTexture(imageNamed: "city-front")
    var texGround = SKTexture(imageNamed: "ground")
    var texPlayer0 = SKTexture(imageNamed: "player0")
    var texPlayer1 = SKTexture(imageNamed: "player1")
    var texSpikeBottom = SKTexture(imageNamed: "spikebottom")
    var texSpikeTop = SKTexture(imageNamed: "spiketop")
    var texMoon = SKTexture(imageNamed: "moon")
    
    class var sharedInstance:GameTextures {
        return GameTexturesSharedInstance
    }
    
    init() {
        textureAtlas = SKTextureAtlas(named: "artwork")
    }
}
