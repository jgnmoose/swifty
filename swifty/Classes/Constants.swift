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
    class var Background:CGFloat    { return 0 }
    class var Sky:CGFloat           { return 1 }
    class var CityBack:CGFloat      { return 2 }
    class var CityFront:CGFloat     { return 3 }
    class var Spikes:CGFloat        { return 4 }
    class var Ground:CGFloat        { return 5 }
    class var Game:CGFloat          { return 6 }
    class var UI:CGFloat            { return 7 }
    class var Flash:CGFloat         { return 8 }
}

class Contact {
    class var Scene:UInt32  { return 1 << 0 }
    class var Object:UInt32 { return 1 << 1 }
    class var Player:UInt32 { return 1 << 2 }
    class var Score:UInt32  { return 1 << 3 }
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
let kGameFont = "EditUndoBrk"
let kFontColor = SKColor.blueColor()

// Music
let kMusicGame = "caustic_chip"
let kMusicType = "mp3"

// Sounds
let kSoundBounce = "bounce.caf"
let kSoundPop = "pop.caf"
let kSoundWhack = "whack.caf"
let kSoundFly = "flapping.caf"
let kSoundFalling = "falling.caf"
let kSoundHitGround = "hitGround.caf"
let kSoundScore = "coin.caf"

// Object Names
let kNameMoon = "Moon"
let kNameCity = "City"
let kNameCityFar = "City Far"
let kNameCityNear = "City Near"
let kNameGround = "Ground"
let kNamePlayer = "Player"
let kNameTutorial = "Tutorial"
let kNameCount = "Count"
let kNameGameLabel = "Game Label"
let kNamePlayButton = "Play Button"
let kNameRetry = "Retry"
let kNameSpike = "Spike"
let kNameSpikeTop = "Top Spike"
let kNameSpikeBottom = "Bottom Spike"
let kNameSpikeSpawn = "Spawn"
let kNameScoreLabel = "Score Label"

// Positions
let kMoonPosition = CGPoint(x: viewSize.width * 0.25, y: viewSize.height * 0.85)