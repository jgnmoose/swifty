//
//  Constants.swift
//  swifty
//
//  Created by Jeremy Novak on 6/11/14.
//  Copyright (c) 2014 Jeremy Novak. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation


let kDebug = true

class GameLayer {
    class var Background:Float  { return 0 }
    class var Sky:Float         { return 1 }
    class var City:Float        { return 2 }
    class var Spikes:Float      { return 3 }
    class var Ground:Float      { return 4 }
    class var Game:Float        { return 5 }
    class var UI:Float          { return 6 }
}

class Contact {
    class var Scene:UInt32  { return 1 << 0 }
    class var Object:UInt32 { return 1 << 1 }
    class var Player:UInt32 { return 1 << 2 }
}

enum GameState:Int {
    case Tutorial
    case Play
    case GameOver
}

// Shared vars
var viewSize:CGSize!
var musicPlayer:AVAudioPlayer!

// Fonts
let kGameFont = "Fipps-Regular"

// Music
let kMusicGame = "copycat"
let kMusicType = "mp3"

// Sounds
let kSoundBounce = "bounce.caf"
let kSoundPop = "pop.caf"
let kSoundWhack = "whack.caf"
let kSoundFly = "flapping.caf"
let kSoundFalling = "falling.caf"
let kSoundHitGround = "hitGround.caf"

// Positions
let kMoonPosition = CGPointMake(viewSize.width * 0.25, viewSize.height * 0.85)

// Game Play
let kGroundSpeed:CGFloat = 2.75
let kSpawnDelay:CGFloat = 1.5
