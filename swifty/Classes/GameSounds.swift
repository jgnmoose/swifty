//
//  GameSounds.swift
//  swifty
//
//  Created by Jeremy Novak on 7/12/14.
//  Copyright (c) 2014 Jeremy Novak. All rights reserved.
//

import SpriteKit

let GameSoundsSharedInstance = GameSounds()

class GameSounds {
   
    class var sharedInstance:GameSounds {
        return GameSoundsSharedInstance
    }
    
    var sounds = [SKAction]()
    let bounce = SKAction.playSoundFileNamed(kSoundBounce, waitForCompletion: false)
    let score = SKAction.playSoundFileNamed(kSoundScore, waitForCompletion: false)
    let falling = SKAction.playSoundFileNamed(kSoundFalling, waitForCompletion: false)
    let flying = SKAction.playSoundFileNamed(kSoundFly, waitForCompletion: false)
    let hitGround = SKAction.playSoundFileNamed(kSoundHitGround, waitForCompletion: false)
    let pop = SKAction.playSoundFileNamed(kSoundPop, waitForCompletion: false)
    let whack = SKAction.playSoundFileNamed(kSoundWhack, waitForCompletion: false)
    
    init() {
        sounds = [bounce, score, falling, flying, hitGround, pop, whack]
    }
}
