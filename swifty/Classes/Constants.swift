//
//  Constants.swift
//  swifty
//
//  Created by Jeremy Novak on 6/11/14.
//  Copyright (c) 2014 Jeremy Novak. All rights reserved.
//

import Foundation
import SpriteKit


let kDebug = true

class GameLayer {
    class var Background:Float  { return 0 }
    class var Sky:Float         { return 1 }
    class var City:Float        { return 2 }
    class var Ground:Float      { return 3 }
    class var Game:Float        { return 4 }
    class var UI:Float          { return 5 }
}

class Contact {
    class var Scene:UInt32  { return 1 << 0 }
    class var Object:UInt32 { return 1 << 1 }
    class var Player:UInt32 { return 1 << 2 }
}

enum GameState {
    case Tutorial
    case Play
    case GameOver
}

// Shared vars
var viewSize:CGSize!

// Fonts
let kGameFont = "Fipps-Regular"

// Sounds
let kSoundBounce = "bounce.caf"
let kSoundPop = "pop.caf"
let kSoundWhack = "whack.caf"
